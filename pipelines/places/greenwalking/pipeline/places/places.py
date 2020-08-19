import logging
from dataclasses import dataclass
from typing import Tuple, Dict, Iterable, Any, TypeVar, Generator, Optional

from apache_beam import Pipeline, ParDo, CoGroupByKey, DoFn, copy, Flatten, MapTuple
from apache_beam.io.filesystems import FileSystems
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions
from google.cloud import firestore
from google.oauth2 import service_account

from greenwalking.core import language, geohash
from greenwalking.pipeline.places import wikidata, wikipedia, fields

K = TypeVar("K")


@dataclass
class GeoPoint:
    latitude: float
    longitude: float


class AddType(DoFn):
    def __init__(self, typ: str):
        super().__init__()
        self._typ = typ

    def process(self, element: Dict[str, Any], *args, **kwargs) -> Generator[Dict[str, Any], None, None]:
        element = copy.copy(element)
        element[fields.TYP] = self._typ
        yield element


class Combine(DoFn):

    TAG_WIKIDATA = "wikidata"
    TAG_WIKIPEDIA = "wikipedia"

    def process(
        self, element: Tuple[K, Dict[str, Iterable[Dict[str, Any]]]], *args, **kwargs
    ) -> Generator[Tuple[K, Dict[str, Any]], None, None]:
        key, tags = element
        wikidata_entries = list(tags[self.TAG_WIKIDATA])
        wikipedia_entries = list(tags[self.TAG_WIKIPEDIA])

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

        geopoint_dict = wikidata.get(fields.GEOPOINT)
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

        yield key, wikidata


class FilterLanguage(DoFn):

    _LANG_TO_DELETE = language.ENGLISH

    def process(self, element: Tuple[K, Dict[str, Any]], *args, **kwargs) -> Generator[Tuple[K, Dict[str, Any]], None, None]:
        key, entry = element
        entry = copy.copy(entry)
        self._delete_non_german(entry)
        yield key, entry

    @staticmethod
    def _delete_non_german(element: Any):
        if isinstance(element, dict):
            if FilterLanguage._LANG_TO_DELETE in element:
                del element[FilterLanguage._LANG_TO_DELETE]
                return
            for _, value in element.items():
                FilterLanguage._delete_non_german(value)
            return

        if not isinstance(element, (str, dict)) and isinstance(element, Iterable):
            for e in element:
                FilterLanguage._delete_non_german(e)


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
    def wd_query_park() -> str:
        return """\
SELECT ?item WHERE {
    # item (instance of) p
    ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183 .
    # p in (park, botanical garden, green space, urban park, recreation area, landscape garden)
    FILTER (?p IN (wd:Q22698, wd:Q167346, wd:Q22652, wd:Q22746, wd:Q2063507, wd:Q15077303 ) )
}"""

    @staticmethod
    def wd_query_monument() -> str:
        # For coordinate examples see https://en.wikibooks.org/wiki/SPARQL/WIKIDATA_Precision,_Units_and_Coordinates#Coordinates
        return """\
SELECT DISTINCT ?item WHERE {
    # item (instance of) p
    ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183;
        # item (coordinate location) coordinate
        wdt:P625 ?coordinate.
    # item "has site links"
    ?article schema:about ?item;
        schema:isPartOf ?sitelink.
    # p in (natural monument in Germany)
    FILTER(?p IN(wd:Q21573182))
}"""


def run(argv=None):
    pipeline_options = PipelineOptions(argv)
    options = pipeline_options.view_as(ParkdataPipelineOptions)
    # Save the main session that defines global import, functions and variables. Otherwise they are not saved during
    # the serialization. Details see https://cloud.google.com/dataflow/docs/resources/faq#how_do_i_handle_nameerrors
    pipeline_options.view_as(SetupOptions).save_main_session = options.save_session
    with Pipeline(options=pipeline_options) as p:
        park_data = (
            p
            | "park/query"
            >> wikidata.Query(
                query=options.wd_query_park(),
                state_file=FileSystems.join(options.base_path, "park-wikidata-ids.txt"),
                user_agent=options.user_agent,
            )
            | "park/fetch"
            >> wikidata.Fetch(FileSystems.join(options.base_path, "park-wikidata-raw-data.json"), user_agent=options.user_agent)
            | "park/add_type" >> ParDo(AddType("park"))
        )

        monument_data = (
            p
            | "monument/query"
            >> wikidata.Query(
                query=options.wd_query_monument(),
                state_file=FileSystems.join(options.base_path, "monument-wikidata-ids.txt"),
                user_agent=options.user_agent,
            )
            | "monument/fetch"
            >> wikidata.Fetch(FileSystems.join(options.base_path, "monument-wikidata-raw-data.json"), user_agent=options.user_agent)
            | "monument/add_type" >> ParDo(AddType("monument"))
        )

        wikidata_data = (
            [park_data, monument_data] | "wikidata/flatten" >> Flatten() | "wikidata/process" >> ParDo(wikidata.Process())
        )

        wikipedia_data = (
            wikidata_data
            | "wikipedia/fetch" >> wikipedia.Fetch(options.base_path, user_agent=options.user_agent)
            | "wikipedia/process" >> ParDo(wikipedia.Process())
        )

        places = (
            {Combine.TAG_WIKIDATA: wikidata_data, Combine.TAG_WIKIPEDIA: wikipedia_data,}
            | "combine/group_by_key" >> CoGroupByKey()
            | "combine/combine" >> ParDo(Combine())
            | "combine/filter_lang" >> ParDo(FilterLanguage())
        )

        (
            places
            | "firestore_output/convert_types" >> MapTuple(use_firestore_types)
            | "firestore_output/write"
            >> ParDo(FirestoreWrite(project=options.project_id, collection="places", credentials="gcp-service-account.json"))
        )
