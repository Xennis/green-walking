import json
import logging
from typing import Any, Tuple, Generator, TypeVar, Optional

from apache_beam import PTransform, pvalue, Flatten, DoFn, Dict, ParDo, Map, MapTuple
from apache_beam.io import ReadFromText, WriteToText
from apache_beam.io.filesystems import FileSystems
from apache_beam.transforms.combiners import Count

from greenwalking.core.clients import WikipediaExtractClient
from greenwalking.pipeline.parkdata import fields

K = TypeVar("K")


def _create_article_list(key: K, value: Dict[str, Any]) -> Tuple[K, Dict[str, str]]:
    title_per_lang = {}
    for lang, entry in value.get(fields.WIKIPEDIA, {}).items():
        title_per_lang[lang] = entry.get(fields.TITLE)
    return key, title_per_lang


class _FetchDoFn(DoFn):
    def __init__(self, user_agent: str):
        super().__init__()
        self._user_agent = user_agent
        self._client = None

    def start_bundle(self):
        self._client = WikipediaExtractClient(self._user_agent)

    def process(
        self, element: Tuple[K, Dict[str, Any]], *args, **kwargs
    ) -> Generator[Tuple[K, Dict[str, Dict[str, Any]]], None, None]:
        known_count: Optional[int] = kwargs.get("known_count")
        if isinstance(known_count, int) and known_count > 0:
            return

        key, title_per_lang = element
        try:
            res = {}
            for lang, title in title_per_lang.items():
                if not title:
                    continue
                res[lang] = self._client.get(lang, title=title)  # type: ignore  # _client is not optional here

            yield key, res
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({element})")


class Fetch(PTransform):
    _STATE_FILE = "wikipedia-raw-data.json"

    def __init__(self, base_path: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._base_path = base_path
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        known = (
            input_or_inputs
            | "known/read" >> ReadFromText(FileSystems.join(self._base_path, self._STATE_FILE), validate=False)
            | "known/json_load" >> Map(lambda element: json.loads(element))
            | "known/kv" >> Map(lambda element: tuple(element)).with_output_types(Tuple[str, Dict[str, Dict[str, Any]]])
        )
        known_count = known | "known_count" >> Count.Globally()

        state_file_split = self._STATE_FILE.split(".")
        new = (
            input_or_inputs
            | "new/create_list" >> MapTuple(_create_article_list)
            # FIXME: Avoid ParDo here to not do parallel requests
            | "new/parse" >> ParDo(_FetchDoFn(user_agent=self._user_agent), known_count=pvalue.AsSingleton(known_count))
        )

        data = [known, new] | "known_new_flatten" >> Flatten()
        (
            data
            | "state/json_dump" >> Map(lambda element: json.dumps(element, sort_keys=True))
            | "state/write"
            >> WriteToText(
                FileSystems.join(self._base_path, state_file_split[0]),
                file_name_suffix=".{}".format(state_file_split[1]),
                shard_name_template="",
            )
        )

        return data
