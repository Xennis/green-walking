import logging

from clients import WikidataEntityClient, CommonsImageInfoClient

from typing import Dict, Any, Iterable


class FetchWikidata:

    def __init__(self, wikidata_client: WikidataEntityClient, commons_client: CommonsImageInfoClient):
        self._wikidata_client = wikidata_client
        self._commons_client = commons_client
        self._cache = {}

    def _do_request_cached(self, entity_id: str) -> Dict[str, Any]:
        if entity_id in self._cache:
            return self._cache[entity_id]
        resp = self._wikidata_client.get(entity_id)
        # Limit to a few fields to reduce the memory consumption of the cache and the amount of data in the output. For
        # example the entity Germany of the property country is a really large entity.
        data = {
            "labels": resp.get("labels"),
            "claims": {
                "instance of": resp.get("claims").get("P31")
            }
        }
        self._cache[entity_id] = data
        return data

    def _resolve_claims(self, claims: Dict[str, Iterable[Dict[str, Any]]]) -> Dict[str, Any]:
        res = {}
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
