import logging
from typing import Any, Generator, Optional

from apache_beam import PTransform, Create, ParDo, DoFn, pvalue, Flatten
from apache_beam.io import WriteToText, ReadFromText
from apache_beam.io.filesystems import FileSystems
from apache_beam.transforms.combiners import Count

from greenwalking.core.clients import WikidataQueryClient


class _QueryDoFn(DoFn):
    def __init__(self, query: str, user_agent: str):
        super().__init__()
        self._query = query
        self._user_agent = user_agent
        self._client: Optional[WikidataQueryClient] = None

    def start_bundle(self):
        self._client = WikidataQueryClient(self._user_agent)

    def process(self, element: Any, *args, **kwargs) -> Generator[str, None, None]:
        known_count: Optional[int] = kwargs.get("known_count")
        if isinstance(known_count, int) and known_count > 0:
            return

        try:
            # TODO: Deduplicate, e.g. set(<fuu>)
            for entity_id in self._client.sparql(self._query):  # type: ignore  # _client is not optional here
                yield entity_id
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e}")


class Query(PTransform):
    _QUERY = """\
            SELECT ?item WHERE {
              # item (instance of) p
              ?item wdt:P31 ?p;
                # item (country) Germany
                wdt:P17 wd:Q183 .
              # p in (park, botanical garden, green space, urban park, recreation area, landscape garden)
              FILTER (?p IN (wd:Q22698, wd:Q167346, wd:Q22652, wd:Q22746, wd:Q2063507, wd:Q15077303 ) )
            }"""

    _STATE_FILE = "wikidata-ids.txt"

    def __init__(self, base_path: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._base_path = base_path
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        known = input_or_inputs | "read" >> ReadFromText(FileSystems.join(self._base_path, self._STATE_FILE), validate=False)
        known_count = known | "known_count" >> Count.Globally()

        state_file_split = self._STATE_FILE.split(".")
        new = (
            input_or_inputs
            | "new/create" >> Create([None])
            | "new/parse"
            >> ParDo(_QueryDoFn(query=self._QUERY, user_agent=self._user_agent), known_count=pvalue.AsSingleton(known_count))
        )

        data = [known, new] | "known_new_flatten" >> Flatten()
        data | "new_write" >> WriteToText(
            FileSystems.join(self._base_path, state_file_split[0]),
            file_name_suffix=".{}".format(state_file_split[1]),
            shard_name_template="",
        )

        return data
