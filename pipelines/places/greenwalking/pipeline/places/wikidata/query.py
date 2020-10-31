import logging
from typing import Any, Generator, Optional, Tuple, TypeVar

from apache_beam import PTransform, ParDo, DoFn
from sqlitedict import SqliteDict

from greenwalking.core import country
from greenwalking.core.clients import WikidataQueryClient
from greenwalking.pipeline.places.ctypes import Typ, EntryId

K = TypeVar("K")


class _CachedFetch(DoFn):
    def __init__(self, cache_file: str, user_agent: str):
        super().__init__()
        self._cache_file = cache_file
        self._user_agent = user_agent
        self._client = None
        self._cache = None

    def start_bundle(self):
        self._client = WikidataQueryClient(self._user_agent)
        self._cache = SqliteDict(self._cache_file, autocommit=True)

    def finish_bundle(self):
        self._cache.close()

    def process(
        self, element: Tuple[Tuple[country.Country, Typ], str], *args, **kwargs
    ) -> Generator[Tuple[EntryId, Tuple[country.Country, Typ]], None, None]:
        # Make the type checker happy
        assert isinstance(self._client, WikidataQueryClient)
        assert isinstance(self._cache, SqliteDict)

        ((country, typ), query) = element
        cache_key = "{country}#{typ}".format(country=country, typ=typ)
        if cache_key in self._cache:
            logging.info("wikidata query cached %s", cache_key)
            for wikidata_id in self._cache[cache_key]:
                yield wikidata_id, (country, typ)
            return

        try:
            res = []
            logging.info("wikidata query request %s", cache_key)
            for wikidata_id in self._client.sparql(query):  # type: ignore  # _client is not optional here
                yield wikidata_id, (country, typ)
                res.append(wikidata_id)

            self._cache[cache_key] = res
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e}")


class Query(PTransform):
    def __init__(self, cache_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._cache_file = cache_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        return input_or_inputs | "fetch" >> ParDo(_CachedFetch(cache_file=self._cache_file, user_agent=self._user_agent))
