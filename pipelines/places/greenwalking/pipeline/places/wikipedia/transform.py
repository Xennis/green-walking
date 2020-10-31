import logging
from typing import Any, Tuple, Generator, TypeVar, Optional, Dict

import apache_beam as beam
from sqlitedict import SqliteDict

from greenwalking.core.clients import WikipediaExtractClient
from greenwalking.pipeline.places import fields
from greenwalking.pipeline.places.ctypes import EntryId

K = TypeVar("K")


class _CachedFetch(beam.DoFn):
    def __init__(self, cache_file: str, user_agent: str):
        super().__init__()
        self._cache_file = cache_file
        self._user_agent = user_agent
        self._client = None
        self._cache = None

    def start_bundle(self):
        self._client = WikipediaExtractClient(self._user_agent)
        self._cache = SqliteDict(self._cache_file, autocommit=True)

    def finish_bundle(self):
        self._cache.close()

    def process(
        self, element: Tuple[EntryId, Dict[str, Any]], *args, **kwargs
    ) -> Generator[Tuple[EntryId, Dict[str, Dict[str, Any]]], None, None]:
        # Make the type checker happy
        assert isinstance(self._client, WikipediaExtractClient)
        assert isinstance(self._cache, SqliteDict)

        key, title_per_lang = element
        if key in self._cache:
            logging.info("wikipedia cached %s", key)
            yield key, self._cache[key]
            return

        try:
            res = {}
            for lang, title in title_per_lang.items():
                if not title:
                    continue
                logging.info("wikipedia request %s: %s %s", key, lang, title)
                res[lang] = self._client.get(lang, title=title)

            self._cache[key] = res
            yield key, res
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({element})")


class _Process(beam.DoFn):
    def process(
        self, element: Tuple[K, Dict[str, Dict[str, Any]]], *args, **kwargs
    ) -> Generator[Tuple[K, Dict[str, Dict[str, Any]]], None, None]:
        key, articles_per_lang = element
        res = {}
        for lang, article_data in articles_per_lang.items():
            res[lang] = self._resolve_article_data(article_data)

        # FIXME: Move filter to the end
        filtered = {}
        for lang, article_data in res.items():
            if not article_data.get(fields.TEXT):
                # Some articles don't have an extract, e.g. https://de.wikipedia.org/w/index.php?title=Alter_Friedhof_Alt-Saarbr%C3%BCcken&oldid=181871454
                continue
            assert article_data.get(fields.LICENSE_URL) is not None, "license URL is not None"
            assert article_data.get(fields.LICENSE_SHORT_NAME) is not None, "license short name is not None"

            filtered[lang] = article_data
        if not filtered:
            return None
        yield key, filtered

    @staticmethod
    def _shorten_licence_name(name: Optional[str]) -> Optional[str]:
        if not name:
            return name
        if name == "Creative Commons Attribution-Share Alike 3.0":
            return "CC BY-SA 3.0"
        return name.strip()

    @staticmethod
    def _fix_protocol_relative_url_for_rightsinfo(url: Optional[str]) -> Optional[str]:
        """The API can output protocol relative URL, e.g. //example.org. These work fine in JavaScript but might not
        work everywhere else."""
        if url is None or not url.startswith("//"):
            return url
        # In 2020 it's hopefully fine to assume HTTPS.
        return url.replace("//", "https://", 1)

    @staticmethod
    def _resolve_article_data(article_data: Dict[str, Any]) -> Dict[str, Any]:
        extract: Optional[str] = article_data.get("extract")
        rightinfo: Dict[str, Any] = article_data.get("rightsinfo", {})

        return {
            fields.TEXT: extract.strip() if extract else None,
            fields.LICENSE_URL: _Process._fix_protocol_relative_url_for_rightsinfo(rightinfo.get("url")),
            fields.LICENSE_SHORT_NAME: _Process._shorten_licence_name(rightinfo.get("text")),
        }


class Transform(beam.PTransform):
    def __init__(self, cache_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._cache_file = cache_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        return (
            input_or_inputs
            | "prepare" >> beam.MapTuple(self._create_article_list)
            # FIXME: Avoid ParDo here to not do parallel requests
            | "fetch" >> beam.ParDo(_CachedFetch(cache_file=self._cache_file, user_agent=self._user_agent))
            | "process" >> beam.ParDo(_Process())
        )

    @staticmethod
    def _create_article_list(key: K, value: Dict[str, Any]) -> Tuple[K, Dict[str, str]]:
        title_per_lang = {}
        for lang, entry in value.get(fields.WIKIPEDIA, {}).items():
            title_per_lang[lang] = entry.get(fields.TITLE)
        return key, title_per_lang
