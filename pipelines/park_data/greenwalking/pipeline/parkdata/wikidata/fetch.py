import json
import logging
import os

from apache_beam import PTransform, ParDo, pvalue, DoFn, Flatten, Map
from apache_beam.io import ReadFromText, WriteToText
from typing import Dict, Any, Iterable, Generator, Optional
from sqlitedict import SqliteDict

from apache_beam.transforms.combiners import Count

from greenwalking.core import language
from greenwalking.core.clients import WikidataEntityClient, CommonsImageInfoClient


class _Fetch:
    def __init__(self, wikidata_client: WikidataEntityClient, commons_client: CommonsImageInfoClient):
        self._wikidata_client = wikidata_client
        self._commons_client = commons_client
        self._cache = SqliteDict("wd_qache.sqlite", autocommit=True)

    def _do_request_cached(self, entity_id: str) -> Dict[str, Any]:
        if entity_id in self._cache:
            return self._cache[entity_id]
        resp = self._wikidata_client.get(entity_id)
        labels = resp.get("labels", {})
        # Limit to a few fields to reduce the memory consumption of the cache and the amount of data in the output. For
        # example the entity Germany of the property country is a really large entity.
        data = {
            "labels": {language.GERMAN: labels.get(language.GERMAN, {}), language.ENGLISH: labels.get(language.ENGLISH, {})},
            "claims": {"instance of": resp.get("claims", {}).get("P31")},
        }
        self._cache[entity_id] = data
        return data

    def close(self):
        if self._cache:
            self._cache.close()

    def _resolve_claims(self, claims: Dict[str, Iterable[Dict[str, Any]]]) -> Dict[str, Any]:
        res: Dict[str, Any] = {}
        for prop_id, values in claims.items():
            prop_name = self._do_request_cached(prop_id).get("labels", {}).get(language.ENGLISH, {}).get("value")
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

    def finish_bundle(self):
        if self._client:
            self._client.close()

    def process(self, element: str, *args, **kwargs) -> Generator[Dict[str, Any], None, None]:
        known_count: Optional[int] = kwargs.get("known_count")
        if isinstance(known_count, int) and known_count > 0:
            return
        try:
            yield self._client.get(element)  # type: ignore  # _client is not optional here
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({element})")


class Fetch(PTransform):
    def __init__(self, state_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._state_file = state_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        state_filename, state_file_ext = os.path.splitext(self._state_file)

        known = (
            input_or_inputs
            | "known/read" >> ReadFromText(self._state_file, validate=False)
            # | "known/fix_none_issue"
            # >> Map(lambda element: element.replace('"en": null', '"en": {}').replace('"de": null', '"de": {}'))
            | "known/json_load" >> Map(lambda element: json.loads(element))
        )

        known_count = known | "known_count" >> Count.Globally()

        new = (
            input_or_inputs
            # FIXME: Avoid ParDo here to not do parallel requests
            | "new/fetch" >> ParDo(_FetchDoFn(user_agent=self._user_agent), known_count=pvalue.AsSingleton(known_count))
        )

        data = [known, new] | "known_new_flatten" >> Flatten()
        (
            data
            | "state/json_dump" >> Map(lambda element: json.dumps(element, sort_keys=True))
            | "state/write" >> WriteToText(state_filename, file_name_suffix=state_file_ext, shard_name_template="",)
        )

        return data
