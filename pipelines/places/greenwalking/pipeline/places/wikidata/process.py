import logging
from typing import Dict, Any, Iterable, List, Optional, Generator, Tuple
from apache_beam import DoFn
from bs4 import BeautifulSoup

from greenwalking.core import language
from greenwalking.pipeline.places import fields


class ProcessDoFn(DoFn):
    def process(self, element: Dict[str, Any], *args, **kwargs) -> Generator[Tuple[str, Dict[str, Any]], None, None]:
        aliases = element.get("aliases", {})
        descriptions = element.get("descriptions", {})
        labels = element.get("labels", {})
        sitelinks = element.get("sitelinks", {})

        claims = self._resolve_claims_by_type(element.get("claims", {}))
        administrative = claims.get("located in the administrative territorial entity", [])
        coordinate_location: List[Dict[str, Any]] = claims.get("coordinate location", [])
        heritage_designation: List[Dict[str, Any]] = claims.get("heritage designation", [])
        instance_of: List[Dict[str, Any]] = claims.get("instance of", [])
        location = claims.get("location")
        officialWebsite = claims.get("official website")
        image: List[List[Dict[str, Any]]] = claims.get("image", [])

        wikidata_id: str = element["title"]

        try:
            yield wikidata_id, {
                "aliases": {
                    language.GERMAN: [e.get("value") for e in aliases.get(language.GERMAN, [])],
                    language.ENGLISH: [e.get("value") for e in aliases.get(language.ENGLISH, [])],
                },
                "categories": {
                    language.GERMAN: self._create_categories(
                        language.GERMAN, instance_of, heritage_designation=heritage_designation
                    ),
                    language.ENGLISH: self._create_categories(
                        language.ENGLISH, instance_of, heritage_designation=heritage_designation
                    ),
                },
                fields.GEOPOINT: {
                    fields.LATITUDE: coordinate_location[0].get("latitude") if coordinate_location else None,
                    fields.LONGITUDE: coordinate_location[0].get("longitude") if coordinate_location else None,
                },
                "commonsUrl": sitelinks.get("commonswiki", {}).get("url"),
                "descriptions": {
                    language.GERMAN: descriptions.get(language.GERMAN, {}).get("value"),
                    language.ENGLISH: descriptions.get(language.ENGLISH, {}).get("value"),
                },
                "image": self._filter_images(image),
                "location": {
                    language.GERMAN: {
                        "location": location[0].get(language.GERMAN, {}).get("value") if location else None,
                        "administrative": administrative[0].get(language.GERMAN, {}).get("value") if administrative else None,
                    },
                    language.ENGLISH: {
                        "location": location[0].get(language.ENGLISH, {}).get("value") if location else None,
                        "administrative": administrative[0].get(language.ENGLISH, {}).get("value") if administrative else None,
                    },
                },
                "name": {
                    language.GERMAN: labels.get(language.GERMAN, {}).get("value"),
                    language.ENGLISH: labels.get(language.ENGLISH, {}).get("value"),
                },
                "officialWebsite": officialWebsite[0] if officialWebsite else None,
                fields.WIKIDATA_ID: wikidata_id,
                fields.WIKIPEDIA: {
                    language.GERMAN: {
                        fields.TITLE: sitelinks.get("dewiki", {}).get("title"),
                        fields.URL: sitelinks.get("dewiki", {}).get("url"),
                    },
                    language.ENGLISH: {
                        fields.TITLE: sitelinks.get("enwiki", {}).get("title"),
                        fields.URL: sitelinks.get("enwiki", {}).get("url"),
                    },
                },
                fields.TYP: element.get(fields.TYP),
            }
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e}")
            logging.exception("failed for id %s: %s", wikidata_id)

    @staticmethod
    def _extract_artist(raw: Optional[Dict[str, Any]]) -> Optional[str]:
        if not raw:
            return None
        value = raw.get("value")
        if not value:
            return None
        # The artist attribute can contain a HTML link
        text = BeautifulSoup(value, features="html.parser").text
        if not text:
            return None
        return text.strip()

    @staticmethod
    def _resolve_commons_media(image_info: Dict[str, Any]) -> Dict[str, Any]:
        ext_meta_data = image_info.get("extmetadata", {})
        # It's safer to parse for False: It's better to wrongly assume a media has a copyright than the other way round.
        copyrighted = bool(ext_meta_data.get("Copyrighted", {}).get("value") != "False")
        return {
            fields.ARTIST: ProcessDoFn._extract_artist(ext_meta_data.get("Artist")),
            fields.COPYRIGHTED: copyrighted,
            fields.DESCRIPTION_URL: image_info.get("descriptionurl"),
            fields.LICENSE_SHORT_NAME: ext_meta_data.get("LicenseShortName", {}).get("value"),
            fields.LICENSE_URL: ext_meta_data.get("LicenseUrl", {}).get("value"),
            fields.URL: image_info.get("url"),
        }

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
                    image_infos = data_val.get("gw", {}).get("imageinfo", [])
                    res[prop].append([ProcessDoFn._resolve_commons_media(info) for info in image_infos])
                elif data_type == "url" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                else:
                    logging.debug("data_type %s and data_val_type %s not handled", data_type, data_val_type)
        return res

    @staticmethod
    def _create_categories(lang: str, instance_of: List[Dict[str, Any]], heritage_designation: List[Dict[str, Any]]) -> List[str]:
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

    # FIXME: Move this to the end of the pipeline
    @staticmethod
    def _filter_images(images: Optional[Iterable[List[Dict[str, Any]]]]) -> Optional[Dict[str, Any]]:
        if not images:
            return None
        for image_infos in images:
            image_info = image_infos[0]
            # The artist name is required to show a proper attribution. There are images like
            # https://commons.wikimedia.org/wiki/File:Lustgarten_3.JPG that have an author but it's not machine-readable
            # (see categories).
            if not image_info.get(fields.ARTIST):
                continue
            if not image_info.get(fields.LICENSE_SHORT_NAME):
                continue
            if not image_info.get(fields.DESCRIPTION_URL):
                continue
            # fields.LICENSE_URL can be None, e.g. for public domain
            return image_info

        return None
