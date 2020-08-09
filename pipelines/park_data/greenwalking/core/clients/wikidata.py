import json
import logging
import urllib.parse
import urllib.request
from typing import Dict, Any, Generator
from SPARQLWrapper import SPARQLWrapper, JSON


class WikidataQueryClient:

    _API_ENDPOINT = "https://query.wikidata.org/sparql"

    def __init__(self, user_agent: str, timeout: int = 60 * 5):
        self._user_agent = user_agent
        self._timeout = timeout

    def _do_sqarql_request(self, query: str) -> Dict[str, Any]:
        sparql = SPARQLWrapper(self._API_ENDPOINT, agent=self._user_agent)
        sparql.setQuery(query)
        sparql.setReturnFormat(JSON)
        sparql.setTimeout(self._timeout)
        return sparql.query().convert()

    def sparql(self, query: str) -> Generator[str, None, None]:
        response = self._do_sqarql_request(query)
        for result in response["results"]["bindings"]:
            url: str = result["item"]["value"]
            entity_id = url.rsplit("/", 1)[1]
            yield entity_id


class WikidataEntityClient:

    _API_ENDPOINT = "https://www.wikidata.org/wiki/Special:EntityData/"

    def __init__(self, user_agent: str, timeout: int = 60 * 5):
        self._user_agent = user_agent
        self._timeout = timeout

    def _do_request(self, entity_id: str) -> Dict[str, Any]:
        req = urllib.request.Request(self._API_ENDPOINT + f"{entity_id}.json")
        req.add_header("User-Agent", self._user_agent)
        resp = urllib.request.urlopen(req, timeout=self._timeout).read()
        return json.loads(resp)

    def get(self, entity: str) -> Dict[str, Any]:
        resp = self._do_request(entity)
        entities: Dict[str, Any] = resp["entities"]
        try:
            return entities[entity]
        except KeyError:
            # A known case that happens: Redirects.
            logging.info(f"entity {entity} not found in entities result")
            return entities["entities"][0]
