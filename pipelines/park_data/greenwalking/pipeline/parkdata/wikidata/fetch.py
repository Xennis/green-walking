import json
import logging

from apache_beam import PTransform, ParDo, pvalue, DoFn, Flatten, Map
from apache_beam.io import ReadFromText, WriteToText
from typing import Dict, Any, Iterable, Generator, Optional

from apache_beam.io.filesystems import FileSystems
from apache_beam.transforms.combiners import Count

from greenwalking.core.clients import WikidataEntityClient, CommonsImageInfoClient


class _Fetch:
    def __init__(self, wikidata_client: WikidataEntityClient, commons_client: CommonsImageInfoClient):
        self._wikidata_client = wikidata_client
        self._commons_client = commons_client
        self._cache: Dict[str, Any] = {}

    def _do_request_cached(self, entity_id: str) -> Dict[str, Any]:
        if entity_id in self._cache:
            return self._cache[entity_id]
        resp = self._wikidata_client.get(entity_id)
        # Limit to a few fields to reduce the memory consumption of the cache and the amount of data in the output. For
        # example the entity Germany of the property country is a really large entity.
        data = {"labels": resp.get("labels"), "claims": {"instance of": resp.get("claims", {}).get("P31")}}
        self._cache[entity_id] = data
        return data

    def _resolve_claims(self, claims: Dict[str, Iterable[Dict[str, Any]]]) -> Dict[str, Any]:
        res: Dict[str, Any] = {}
        for prop_id, values in claims.items():
            prop_name = self._do_request_cached(prop_id).get("labels", {}).get("en", {}).get("value")
            if not isinstance(prop_name, str):
                logging.warning("type of property %s is %s, want str", prop_id, type(prop_id))
                continue

            res[prop_name] = []
            for value in values:
                main_snak = value.get("mainsnak", {})
                data_type = main_snak.get("datatype")
                data_val = main_snak.get("datavalue", {})
                data_val_val = data_val.get("value", {})

                if data_type == "wikibase-item":
                    entity_id = data_val_val.get("id")
                    if entity_id is None:
                        logging.warning("datalue.value has no ID: %s", data_val)
                        continue
                    data_val["gw"] = self._do_request_cached(entity_id)

                elif data_type == "commonsMedia":
                    data_val["gw"] = self._commons_client.get(data_val_val)

                res[prop_name].append(value)
        return res

    def get(self, entity_id: str) -> Dict[str, Any]:
        entity_data = self._wikidata_client.get(entity_id)
        entity_data["claims"] = self._resolve_claims(entity_data.get("claims", {}))
        return entity_data


class _FetchDoFn(DoFn):
    def __init__(self, user_agent: str):
        super().__init__()
        self._user_agent = user_agent
        self._client = None
        self._commons_client = None

    def start_bundle(self):
        self._client = _Fetch(
            wikidata_client=WikidataEntityClient(self._user_agent), commons_client=CommonsImageInfoClient(self._user_agent)
        )

    def process(self, element: str, *args, **kwargs) -> Generator[Dict[str, Any], None, None]:
        known_count: Optional[int] = kwargs.get("known_count")
        if isinstance(known_count, int) and known_count > 0:
            return
        try:
            yield self._client.get(element)  # type: ignore  # _client is not optional here
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({element})")


class Fetch(PTransform):
    _STATE_FILE = "wikidata-raw-data.json"

    def __init__(self, base_path: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._base_path = base_path
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        known = (
            input_or_inputs
            | "known/read" >> ReadFromText(FileSystems.join(self._base_path, self._STATE_FILE), validate=False)
            | "known/json_load" >> Map(lambda element: json.loads(element))
        )

        known_count = known | "known_count" >> Count.Globally()

        state_file_split = self._STATE_FILE.split(".")
        new = (
            input_or_inputs
            # FIXME: Avoid ParDo here to not do parallel requests
            | "new/fetch" >> ParDo(_FetchDoFn(user_agent=self._user_agent), known_count=pvalue.AsSingleton(known_count))
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
