import logging
from dataclasses import dataclass
from typing import Tuple, Dict, Iterable, Any, TypeVar, Generator, Optional, List

from apache_beam import Pipeline, ParDo, CoGroupByKey, DoFn, copy, MapTuple, Create, GroupByKey
from apache_beam.io.filesystems import FileSystems
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions
from google.cloud import firestore
from google.oauth2 import service_account
from sqlitedict import SqliteDict

from greenwalking.core import language, geohash
from greenwalking.pipeline.places import wikidata, wikipedia, fields, commons
from greenwalking.pipeline.places.ctypes import EntryId, Typ, TYP_PARK, TYP_MONUMENT, TYP_NATURE, TYP_HERITAGE
from greenwalking.pipeline.places.queries import wd_queries

K = TypeVar("K")


@dataclass
class GeoPoint:
    latitude: float
    longitude: float


class Combine(DoFn):

    TAG_COMMONS = "commons"
    TAG_WIKIDATA = "wikidata"
    TAG_WIKIPEDIA = "wikipedia"

    def process(
        self, element: Tuple[K, Dict[str, Iterable[Any]]], *args, **kwargs
    ) -> Generator[Tuple[K, Dict[str, Any]], None, None]:
        key, tags = element
        commons_entries: Iterable[Iterable[Dict[str, Any]]] = tags[self.TAG_COMMONS]
        wikidata_entries: List[Dict[str, Any]] = list(tags[self.TAG_WIKIDATA])
        wikipedia_entries: List[Dict[str, Any]] = list(tags[self.TAG_WIKIPEDIA])

        # FIXME: Clean that up. Avoid duplicates early.
        # Because of redirect more then 1 is possible
        assert len(wikidata_entries) >= 1, f">=1 wikidata element for {key}, got {len(wikidata_entries)}"
        wikidata = copy.copy(wikidata_entries[0])
        # assert len(wikipedia_entries) <= 1, f"<=1 wikipedia element for {key}, got {len(wikipedia_entries)}"
        wikipedia = wikipedia_entries[0] if wikipedia_entries else None

        urls_per_lang = {}
        for lang, entry in wikidata.get(fields.WIKIPEDIA, {}).items():
            urls_per_lang[lang] = entry.get(fields.URL)

        del wikidata[fields.WIKIPEDIA]
        wikidata["wikipediaUrl"] = urls_per_lang

        if wikipedia:
            wikidata["extract"] = wikipedia

        geopoint_dict = wikidata[fields.GEOPOINT]
        latitude = geopoint_dict.get(fields.LATITUDE)
        longitude = geopoint_dict.get(fields.LONGITUDE)
        if not latitude or not longitude:
            # FIXME: Move this into the query, i.e. filter for records with a location.
            logging.info(f"Skipped {key} because it has no latitude or longitude")
            return
        # At this point latitude/longitude can be an float or integer (e.g. 9 instead of 9.0). Ensure float.
        geopoint = GeoPoint(latitude=float(latitude), longitude=float(longitude))
        wikidata[fields.GEOPOINT] = geopoint
        wikidata[fields.GEOHASH] = geohash.encode(latitude=geopoint.latitude, longitude=geopoint.longitude)

        wikidata[fields.IMAGE] = self._filter_images(commons_entries)

        wikidata[fields.TYP] = self._main_type(wikidata[fields.TYPES])
        del wikidata[fields.TYPES]

        yield key, wikidata

    @staticmethod
    def _filter_images(images: Optional[Iterable[Iterable[Dict[str, Any]]]]) -> Optional[Dict[str, Any]]:
        if not images:
            return None
        for image_infos in images:
            image_info = list(image_infos)[0]
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

    @staticmethod
    def _main_type(types: Iterable[Typ]) -> Typ:
        types = list(types)
        if TYP_PARK in types:
            return TYP_PARK
        if TYP_MONUMENT in types:
            return TYP_MONUMENT
        if TYP_NATURE in types:
            return TYP_NATURE
        if TYP_HERITAGE in types:
            return TYP_HERITAGE
        return TYP_PARK


class FirestoreWrite(DoFn):

    # The total maximimum is 500. Source: https://firebase.google.com/docs/firestore/manage-data/transactions
    _MAX_DOCUMENTS = 250

    def __init__(self, project: str, collection: str, credentials: str):
        super().__init__()
        self._project = project
        self._collection = collection
        self._credentials = credentials
        self._client = None
        self._mutations: Dict[str, Any] = {}

    def start_bundle(self):
        self._mutations = {}
        credentials = service_account.Credentials.from_service_account_file(self._credentials)
        self._client = firestore.Client(project=self._project, credentials=credentials)

    def finish_bundle(self):
        if self._mutations:
            self._flash_batch()

    def process(self, element: Tuple[str, Any], *args, **kwargs) -> None:
        (key, value) = element
        self._mutations[key] = value
        if len(self._mutations) > self._MAX_DOCUMENTS:
            self._flash_batch()

    def _flash_batch(self):
        client: firestore.Client = self._client
        batch = client.batch()
        for doc_id, doc in self._mutations.items():
            ref = client.collection(self._collection).document(doc_id)
            batch.set(ref, doc)
        _ = batch.commit()
        self._mutations = {}


class OutputNewOrChangedEntires(DoFn):
    def __init__(self, cache_file: str):
        super().__init__()
        self._cache_file = cache_file
        self._cache = None

    def start_bundle(self):
        self._cache = SqliteDict(self._cache_file, autocommit=True)

    def finish_bundle(self):
        self._cache.close()

    def process(
        self, element: Tuple[EntryId, Dict[str, Any]], *args, **kwargs
    ) -> Generator[Tuple[EntryId, Dict[str, Any]], None, None]:
        # Make the type checker happy
        assert isinstance(self._cache, SqliteDict)

        (wikidata_id, entry) = element
        cached_entry = self._cache.get(wikidata_id)
        if cached_entry is None or cached_entry != entry:
            self._cache[wikidata_id] = entry
            yield wikidata_id, entry


def use_firestore_types(key: K, value: Dict[str, Any]) -> Tuple[K, Dict[str, Any]]:
    """The pipeline itself should be independent from Firestore types because that is just one possible sink. That's why
    this function here should be called just before writing to Firestore."""
    geopoint: Optional[GeoPoint] = value.get(fields.GEOPOINT)
    if geopoint:
        value = copy.copy(value)
        value[fields.GEOPOINT] = firestore.GeoPoint(latitude=geopoint.latitude, longitude=geopoint.longitude)
    return key, value


class ParkdataPipelineOptions(PipelineOptions):
    @classmethod
    def _add_argparse_args(cls, parser):
        # User-Agent policy: https://w.wiki/CX6
        parser.add_argument(
            "--user_agent", type=str, help="User agent", default="green-walking/0.1 (https://github.com/Xennis/green-walking)"
        )

        parser.add_argument("--base_path", default=".", dest="base_path", type=str, help="Base path for all files")
        parser.add_argument("--project-id", dest="project_id", type=str, help="GCP project ID", required=True)

        parser.add_argument(
            "--no-save-session",
            action="store_false",  # i.e. value is set to True if parameter is *not* set
            dest="save_session",
            help=(
                "If the parameter is set no session will be saved. That can be used for running tests with the local"
                "runner. Details see --save_main_session in Beams SetupOptions class."
            ),
        )

    @staticmethod
    def supported_languages():
        return [language.ENGLISH, language.GERMAN]


def run(argv=None):
    pipeline_options = PipelineOptions(argv)
    options = pipeline_options.view_as(ParkdataPipelineOptions)
    # Save the main session that defines global import, functions and variables. Otherwise they are not saved during
    # the serialization. Details see https://cloud.google.com/dataflow/docs/resources/faq#how_do_i_handle_nameerrors
    pipeline_options.view_as(SetupOptions).save_main_session = options.save_session
    with Pipeline(options=pipeline_options) as p:
        wikidata_data, commons_ids = (
            p
            | "wikidata_query/create" >> Create(wd_queries())
            | "wikidata/query"
            >> wikidata.Query(FileSystems.join(options.base_path, "wikidata_query_cache.sqlite"), user_agent=options.user_agent,)
            | "wikidata/group" >> GroupByKey()
            | "wikidata/fetch"
            >> wikidata.Transform(
                options.supported_languages(),
                cache_file=FileSystems.join(options.base_path, "wikidata_cache.sqlite"),
                user_agent=options.user_agent,
            )
        )

        commons_data = commons_ids | "commons" >> commons.Transform(
            FileSystems.join(options.base_path, "commons_cache.sqlite"), user_agent=options.user_agent
        )

        wikipedia_data = wikidata_data | "wikipedia" >> wikipedia.Transform(
            FileSystems.join(options.base_path, "wikipedia_qache.sqlite"), user_agent=options.user_agent
        )

        changed_places = (
            {Combine.TAG_COMMONS: commons_data, Combine.TAG_WIKIDATA: wikidata_data, Combine.TAG_WIKIPEDIA: wikipedia_data,}
            | "combine/group_by_key" >> CoGroupByKey()
            | "combine/combine" >> ParDo(Combine())
            | "combine/changed" >> ParDo(OutputNewOrChangedEntires(FileSystems.join(options.base_path, "output.sqlite")))
        )

        (
            changed_places
            | "firestore_output/convert_types" >> MapTuple(use_firestore_types)
            | "firestore_output/write"
            >> ParDo(FirestoreWrite(project=options.project_id, collection="places_v2", credentials="gcp-service-account.json"))
        )
