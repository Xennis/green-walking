import json
import logging
from collections import Iterable
from typing import Tuple, Dict, Iterable, Any, TypeVar, Generator

from apache_beam import Pipeline, ParDo, CoGroupByKey, DoFn, copy, Values, Map
from apache_beam.io import WriteToText
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions

from greenwalking.core import language
from greenwalking.pipeline.parkdata import wikidata, wikipedia, fields

K = TypeVar("K")


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

        # FIXME: Move this to the end of the pipeline. Add metric.
        coordinateLoc = wikidata.get(fields.COORDINATE_LOCATION)
        latitude = coordinateLoc.get(fields.LATITUDE)
        if not latitude:
            logging.info(f"Skipped {key} because it has no latitude")
            return
        longitude = coordinateLoc.get(fields.LONGITUDE)
        if not longitude:
            logging.info(f"Skipped {key} because it has no longitude")
            return
        wikidata[fields.COORDINATE_LOCATION] = {
            # The latitude/longitude fields in the app are loaded as double. At this point it can be an
            # integer (e.g. 9 instead of 9.0).
            fields.LATITUDE: float(latitude),
            fields.LONGITUDE: float(longitude),
        }

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


class ParkdataPipelineOptions(PipelineOptions):
    @classmethod
    def _add_argparse_args(cls, parser):
        # User-Agent policy: https://w.wiki/CX6
        parser.add_argument(
            "--user_agent", type=str, help="User agent", default="green-walking/0.1 (https://github.com/Xennis/green-walking)"
        )

        parser.add_argument("--base_path", default=".", dest="base_path", type=str, help="Base path for all files")

        parser.add_argument(
            "--no-save-session",
            action="store_false",  # i.e. value is set to True if parameter is *not* set
            dest="save_session",
            help=(
                "If the parameter is set no session will be saved. That can be used for running tests with the local"
                "runner. Details see --save_main_session in Beams SetupOptions class."
            ),
        )


def run(argv=None):
    pipeline_options = PipelineOptions(argv)
    parkdata_options = pipeline_options.view_as(ParkdataPipelineOptions)
    # Save the main session that defines global import, functions and variables. Otherwise they are not saved during
    # the serialization. Details see https://cloud.google.com/dataflow/docs/resources/faq#how_do_i_handle_nameerrors
    pipeline_options.view_as(SetupOptions).save_main_session = parkdata_options.save_session
    with Pipeline(options=pipeline_options) as p:
        wikidata_data = (
            p
            | "wikidata/query" >> wikidata.Query(parkdata_options.base_path, user_agent=parkdata_options.user_agent)
            | "wikidata/fetch" >> wikidata.Fetch(parkdata_options.base_path, user_agent=parkdata_options.user_agent)
            | "wikidata/process" >> ParDo(wikidata.Process())
        )

        wikipedia_data = (
            wikidata_data
            | "wikipedia/fetch" >> wikipedia.Fetch(parkdata_options.base_path, user_agent=parkdata_options.user_agent)
            | "wikipedia/process" >> ParDo(wikipedia.Process())
        )

        (
            {Combine.TAG_WIKIDATA: wikidata_data, Combine.TAG_WIKIPEDIA: wikipedia_data,}
            | "combine/group_by_key" >> CoGroupByKey()
            | "combine/combine" >> ParDo(Combine())
            | "combine/filter_lang" >> ParDo(FilterLanguage())
            | "combine/values" >> Values()
            | "combine/json_dump" >> Map(lambda element: json.dumps(element, sort_keys=True))
            | "combine/write" >> WriteToText("output", file_name_suffix=".json", shard_name_template="")
        )
