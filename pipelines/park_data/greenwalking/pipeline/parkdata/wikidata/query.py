import logging
import os
from typing import Any, Generator, Optional

from apache_beam import PTransform, Create, ParDo, DoFn, pvalue, Flatten
from apache_beam.io import WriteToText, ReadFromText
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

    def process(self, element: Any, *args, **kwargs) -> Generator[str, None, None]:  # type: ignore  # missing return statement
        known_count: Optional[int] = kwargs.get("known_count")
        if isinstance(known_count, int) and known_count > 0:
            return  # type: ignore  # return value expected

        try:
            return self._client.sparql(self._query)  # type: ignore  # _client is not optional here
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e}")


class Query(PTransform):
    def __init__(self, query: str, state_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._query = query
        self._state_file = state_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        state_filename, state_file_ext = os.path.splitext(self._state_file)

        known = input_or_inputs | "read" >> ReadFromText(self._state_file, validate=False)
        known_count = known | "known_count" >> Count.Globally()

        new = (
            input_or_inputs
            | "new/create" >> Create([None])
            | "new/parse"
            >> ParDo(_QueryDoFn(query=self._query, user_agent=self._user_agent), known_count=pvalue.AsSingleton(known_count))
        )

        data = [known, new] | "known_new_flatten" >> Flatten()
        data | "new_write" >> WriteToText(
            state_filename, file_name_suffix=state_file_ext, shard_name_template="",
        )

        return data
