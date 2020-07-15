from typing import Dict, Any, Optional

from clients import WikipediaExtractClient
from core import fields


class FetchWikipedia:

    def __init__(self, client: WikipediaExtractClient):
        self._client = client

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

    def _fetch(self, lang: str, title: str) -> Dict[str, Any]:
        resp: Dict[str, Any] = self._client.get(lang, title=title)
        extract: Optional[str] = resp.get("extract")
        rightinfo: Optional[Dict[str, Any]] = resp.get("rightsinfo", {})

        return {
            fields.TEXT: extract.strip() if extract else None,
            fields.LICENSE_URL: self._fix_protocol_relative_url_for_rightsinfo(rightinfo.get("url")),
            fields.LICENSE_SHORT_NAME: self._shorten_licence_name(rightinfo.get("text")),
        }

    def process(self, title_per_lang: Dict[str, Optional[str]]) -> Dict[str, Any]:
        res = {}
        for lang, title in title_per_lang.items():
            if not title:
                continue
            extract = self._fetch(lang, title=title)
            text = extract.get(fields.TEXT)
            if not text:
                # Some articles don't have an extract, e.g. https://de.wikipedia.org/w/index.php?title=Alter_Friedhof_Alt-Saarbr%C3%BCcken&oldid=181871454
                continue
            assert extract.get(fields.LICENSE_URL) is not None, "license URL is not None"
            assert extract.get(fields.LICENSE_SHORT_NAME) is not None, "license short name is not None"
            res[lang] = extract
        return res
