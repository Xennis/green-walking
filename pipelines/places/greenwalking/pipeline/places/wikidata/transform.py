import logging
from typing import Dict, Any, Iterable, Generator, Tuple, List, Optional, TypeVar

import apache_beam as beam
from apache_beam import pvalue
from sqlitedict import SqliteDict

from greenwalking.core import language, country
from greenwalking.core.clients import WikidataEntityClient
from greenwalking.pipeline.places import fields
from greenwalking.pipeline.places.ctypes import Typ, EntryId

T = TypeVar("T")


class Property:
    ADMINISTRATIVE = "P131"  # located in the administrative territorial entity
    COORDINATE_LOCATION = "P625"
    HERITAGE_DESIGNATION = "P1435"
    INSTANCE_OF = "P31"
    LOCATION = "P276"
    OFFICIAL_WEBSITE = "P856"

    ALL = [ADMINISTRATIVE, COORDINATE_LOCATION, HERITAGE_DESIGNATION, INSTANCE_OF, LOCATION, OFFICIAL_WEBSITE]


class _CachedFetch(beam.DoFn):

    _CACHE_KEY_MAIN = "main"
    _CACHE_KEY_COMMONS = "commons"

    def __init__(self, languages: List[language.Language], cache_file: str, user_agent: str):
        super().__init__()
        self._languages = languages
        self._cache_file = cache_file
        self._user_agent = user_agent
        self._client = None
        self._cache = None
        self._cache_entities = None

    def start_bundle(self):
        self._client = WikidataEntityClient(self._user_agent)
        self._cache = SqliteDict(self._cache_file, autocommit=True)
        # TODO: Input file name as argument
        self._cache_entities = SqliteDict("wd_qache.sqlite", autocommit=True)

    def finish_bundle(self):
        self._cache.close()
        self._cache_entities.close()

    def process(
        self, element: Tuple[EntryId, T], *args, **kwargs
    ) -> Generator[Tuple[Tuple[EntryId, T], Dict[str, Any]], None, None]:
        # Make the type checker happy
        assert isinstance(self._client, WikidataEntityClient)
        assert isinstance(self._cache, SqliteDict)
        assert isinstance(self._cache_entities, SqliteDict)

        wikidata_id, _ = element
        if wikidata_id in self._cache:
            logging.info("wikidata cached %s", wikidata_id)
            cached = self._cache[wikidata_id]
            yield element, cached.get(self._CACHE_KEY_MAIN)
            cached_commons = cached.get(self._CACHE_KEY_COMMONS)
            if cached_commons:
                yield pvalue.TaggedOutput(Transform._TAG_COMMONS, (wikidata_id, cached_commons))
            return

        try:
            logging.info("wikidata request %s", wikidata_id)
            entity_data = self._client.get(wikidata_id)
            claims, commons_media = self._resolve_claims(entity_data.get("claims", {}))
            entity_data[fields.CLAIMS] = claims

            yield element, entity_data
            yield pvalue.TaggedOutput(Transform._TAG_COMMONS, (wikidata_id, commons_media))
            self._cache[wikidata_id] = {self._CACHE_KEY_MAIN: entity_data, self._CACHE_KEY_COMMONS: commons_media}
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({wikidata_id})")

    def _do_request_cached(self, entity_id: str) -> Dict[str, Any]:
        # Make the type checker happy
        assert isinstance(self._client, WikidataEntityClient)
        assert isinstance(self._cache_entities, SqliteDict)

        if entity_id in self._cache_entities:
            logging.info("wikidata entity cached %s", entity_id)
            return self._cache_entities[entity_id]

        logging.info("wikidata entity request %s", entity_id)
        resp = self._client.get(entity_id)
        labels = resp.get("labels", {})
        # Limit to a few fields to reduce the memory consumption of the cache and the amount of data in the output. For
        # example the entity Germany of the property country is a really large entity.
        data = {
            "labels": {lang: labels.get(lang, {}) for lang in self._languages},
            "claims": {"instance of": resp.get("claims", {}).get(Property.INSTANCE_OF)},
        }
        self._cache_entities[entity_id] = data
        return data

    def _resolve_claims(self, claims: Dict[str, Iterable[Dict[str, Any]]]) -> Tuple[Dict[str, Any], List[str]]:
        res: Dict[str, Any] = {}
        commons_media: List[str] = []
        for prop_id, values in claims.items():
            res[prop_id] = []
            for value in values:
                main_snak = value.get("mainsnak", {})
                data_type = main_snak.get("datatype")
                data_val = main_snak.get("datavalue", {})
                data_val_val = data_val.get("value", {})

                if data_type == "wikibase-item":
                    if prop_id not in Property.ALL:
                        logging.info("skip: %s", prop_id)
                        continue

                    entity_id = data_val_val.get("id")
                    if entity_id is None:
                        logging.warning("datalue.value has no ID: %s", data_val)
                        continue
                    data_val["gw"] = self._do_request_cached(entity_id)

                elif data_type == "commonsMedia":
                    commons_media.append(data_val_val)

                res[prop_id].append(value)
        return res, commons_media


class _Process(beam.DoFn):
    def __init__(self, languages: List[language.Language]):
        super().__init__()
        self._languages = languages

    def process(
        self, element: Tuple[Tuple[Any, Iterable[Tuple[country.Country, Typ]]], Dict[str, Any]], *args, **kwargs
    ) -> Generator[Tuple[str, Dict[str, Any]], None, None]:
        (_, query_metadata), value = element
        aliases = value.get("aliases", {})
        descriptions = value.get("descriptions", {})
        labels = value.get("labels", {})
        sitelinks = value.get("sitelinks", {})

        claims = self._resolve_claims_by_type(value.get("claims", {}))
        administrative = claims.get(Property.ADMINISTRATIVE, [])
        coordinate_location: List[Dict[str, Any]] = claims.get(Property.COORDINATE_LOCATION, [])
        heritage_designation: List[Dict[str, Any]] = claims.get(Property.HERITAGE_DESIGNATION, [])
        instance_of: List[Dict[str, Any]] = claims.get(Property.INSTANCE_OF, [])
        location = claims.get(Property.LOCATION)
        officialWebsite = claims.get(Property.OFFICIAL_WEBSITE)

        wikidata_id: str = value["title"]
        countries, types = self._query_metadata(query_metadata)

        try:
            yield wikidata_id, {
                fields.ALIASES: {lang: [e.get("value") for e in aliases.get(lang, [])] for lang in self._languages},
                fields.CATEGORIES: {
                    lang: self._create_categories(lang, instance_of, heritage_designation=heritage_designation)
                    for lang in self._languages
                },
                fields.GEOPOINT: {
                    fields.LATITUDE: coordinate_location[0].get("latitude") if coordinate_location else None,
                    fields.LONGITUDE: coordinate_location[0].get("longitude") if coordinate_location else None,
                },
                "commonsUrl": sitelinks.get("commonswiki", {}).get("url"),
                fields.DESCRIPTION: {lang: descriptions.get(lang, {}).get("value") for lang in self._languages},
                fields.LOCATION: {
                    lang: {
                        "location": location[0].get(lang, {}).get("value") if location else None,
                        "administrative": administrative[0].get(lang, {}).get("value") if administrative else None,
                    }
                    for lang in self._languages
                },
                fields.NAME: {lang: labels.get(lang, {}).get("value") for lang in self._languages},
                "officialWebsite": officialWebsite[0] if officialWebsite else None,
                fields.WIKIDATA_ID: wikidata_id,
                fields.WIKIPEDIA: {
                    lang: {
                        fields.TITLE: sitelinks.get("{}wiki".format(lang.lower()), {}).get("title"),
                        fields.URL: sitelinks.get("{}wiki".format(lang.lower()), {}).get("url"),
                    }
                    for lang in self._languages
                },
                # TODO: Consider all countries and set language based on country.
                fields.COUNTRY: countries[0],
                fields.COUNTRY_LANGUAGE: [language.GERMAN],
                fields.TYPES: types,
            }
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e}")
            logging.exception("failed for id %s: %s", wikidata_id)

    @staticmethod
    def _resolve_claims_by_type(claims: Dict[str, Iterable[Dict[str, Any]]]) -> Dict[str, Any]:
        res: Dict[str, Any] = {}
        for prop, values in claims.items():
            res[prop] = []
            for value in values:
                mainsnak = value.get("mainsnak", {})
                data_type = mainsnak.get("datatype")
                data_val = mainsnak.get("datavalue", {})
                data_val_type = data_val.get("type")

                if data_type == "string" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                elif data_type == "globe-coordinate" and data_val_type == "globecoordinate":
                    res[prop].append(data_val.get("value", {}))
                elif data_type == "wikibase-item" and data_val_type == "wikibase-entityid":
                    res[prop].append(data_val.get("gw", {}).get("labels", {}))
                elif data_type == "commonsMedia" and data_val_type == "string":
                    pass  # Handled in the commons pipeline
                elif data_type == "url" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                else:
                    logging.debug("data_type %s and data_val_type %s not handled", data_type, data_val_type)
        return res

    @staticmethod
    def _create_categories(
        lang: language.Language, instance_of: List[Dict[str, Any]], heritage_designation: List[Dict[str, Any]]
    ) -> List[str]:
        res = []
        for category in instance_of + heritage_designation:
            label: Optional[str] = category.get(lang, {}).get("value")
            if not label:
                continue
            if label in res:
                continue  # Deduplicate labels
            res.append(label)

        if len(res) <= 5:
            return res
        # FIXME: Move this to the end of the pipeline
        # Limit the number of categories. Pick the one with the shortest name because long names get truncated in the
        # app anyway.
        res.sort(key=len)
        return res[0:5]

    @staticmethod
    def _query_metadata(entries: Iterable[Tuple[country.Country, Typ]]) -> Tuple[List[country.Country], List[Typ]]:
        countries = []
        types = []
        for entry in entries:
            (country, typ) = entry
            if country not in countries:
                countries.append(country)
            if typ not in types:
                types.append(typ)
        return countries, types


class Transform(beam.PTransform):
    _TAG_MAIN = "main"
    _TAG_COMMONS = "commons"

    def __init__(self, languages: List[language.Language], cache_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._languages = languages
        self._cache_file = cache_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        wikidata_commons_data = (
            input_or_inputs
            # FIXME: Avoid ParDo here to not do parallel requests
            | "fetch"
            >> beam.ParDo(_CachedFetch(self._languages, cache_file=self._cache_file, user_agent=self._user_agent)).with_outputs(
                self._TAG_COMMONS, main=self._TAG_MAIN
            )
        )
        wikidata_data = wikidata_commons_data[self._TAG_MAIN] | "process" >> beam.ParDo(_Process(self._languages))
        return wikidata_data, wikidata_commons_data[self._TAG_COMMONS]
