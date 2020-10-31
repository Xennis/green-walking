import logging
from typing import Tuple, Iterable, Generator, Dict, Any, Optional, List, TypeVar

from apache_beam import PTransform, DoFn, ParDo
from bs4 import BeautifulSoup
from sqlitedict import SqliteDict

from greenwalking.core.clients import CommonsImageInfoClient
from greenwalking.pipeline.places import fields
from greenwalking.pipeline.places.ctypes import EntryId

K = TypeVar("K")


class _CachedFetch(DoFn):
    def __init__(self, cache_file: str, user_agent: str):
        super().__init__()
        self._cache_file = cache_file
        self._user_agent = user_agent
        self._client = None
        self._cache = None

    def start_bundle(self):
        self._client = CommonsImageInfoClient(self._user_agent)
        self._cache = SqliteDict(self._cache_file, autocommit=True)

    def finish_bundle(self):
        self._cache.close()

    def process(
        self, element: Tuple[EntryId, Iterable[str]], *args, **kwargs
    ) -> Generator[Tuple[EntryId, Dict[str, Any]], None, None]:
        # Make the type checker happy
        assert isinstance(self._client, CommonsImageInfoClient)
        assert isinstance(self._cache, SqliteDict)

        wikidata_id, file_names = element
        if wikidata_id in self._cache:
            logging.info("commons cached %s", wikidata_id)
            for cached_media in self._cache[wikidata_id]:
                yield wikidata_id, cached_media
            return

        try:
            res = []
            for filename in file_names:
                if not filename:
                    continue
                logging.info("commons request %s: %s", wikidata_id, filename)
                media = self._client.get(filename)
                res.append(media)
                yield wikidata_id, media

            self._cache[wikidata_id] = res
        except Exception as e:
            logging.warning(f"{self.__class__.__name__} error {type(e).__name__}: {e} ({element})")


class _Process(DoFn):
    def process(
        self, element: Tuple[K, Dict[str, Any]], *args, **kwargs
    ) -> Generator[Tuple[K, Iterable[Dict[str, Any]]], None, None]:
        key, entry = element
        media_infos: List[Dict[str, Any]] = entry.get("imageinfo", [])
        yield key, [self._media_infos(info) for info in media_infos]

    @staticmethod
    def _extract_artist(raw: Optional[Dict[str, Any]]) -> Optional[str]:
        if not raw:
            return None
        value = raw.get("value")
        if not value:
            return None
        # The artist attribute can contain a HTML link
        text = BeautifulSoup(value, features="html.parser").text
        if not text:
            return None
        return text.strip()

    @staticmethod
    def _media_infos(image_info: Dict[str, Any]) -> Dict[str, Any]:
        ext_meta_data = image_info.get("extmetadata", {})
        # It's safer to parse for False: It's better to wrongly assume a media has a copyright than the other way round.
        copyrighted = bool(ext_meta_data.get("Copyrighted", {}).get("value") != "False")
        return {
            fields.ARTIST: _Process._extract_artist(ext_meta_data.get("Artist")),
            fields.COPYRIGHTED: copyrighted,
            fields.DESCRIPTION_URL: image_info.get("descriptionurl"),
            fields.LICENSE_SHORT_NAME: ext_meta_data.get("LicenseShortName", {}).get("value"),
            fields.LICENSE_URL: ext_meta_data.get("LicenseUrl", {}).get("value"),
            fields.URL: image_info.get("url"),
        }


class Transform(PTransform):
    def __init__(self, cache_file: str, user_agent: str, **kwargs):
        super().__init__(**kwargs)
        self._cache_file = cache_file
        self._user_agent = user_agent

    def expand(self, input_or_inputs):
        return (
            input_or_inputs
            # FIXME: Avoid ParDo here to not do parallel requests
            | "fetch" >> ParDo(_CachedFetch(cache_file=self._cache_file, user_agent=self._user_agent))
            | "process" >> ParDo(_Process())
        )
