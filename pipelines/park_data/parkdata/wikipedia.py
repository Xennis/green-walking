from typing import Dict, Any, Optional

from clients import WikipediaExtractClient


class ProcessWikipedia:

    def __init__(self, client: WikipediaExtractClient):
        self._client = client

    @staticmethod
    def _shorten_licence_name(name: Optional[str]) -> Optional[str]:
        if not name:
            return name
        if name == "Creative Commons Attribution-Share Alike 3.0":
            return "CC BY-SA 3.0"
        return name

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
        extract: str = resp.get("extract")
        rightinfo = resp.get("rightsinfo")

        return {
            "text": extract.rstrip("\n") if extract else None,
            "licenseUrl": self._fix_protocol_relative_url_for_rightsinfo(rightinfo.get("url")),
            "licenseShortName": self._shorten_licence_name(rightinfo.get("text")),
        }

    def process(self, urls: Dict[str, Optional[str]]) -> Dict[str, Any]:
        res = {}
        for lang, url in urls.items():
            if not url:
                continue
            title = url.rsplit("/wiki/", 1)[1]
            res[lang] = self._fetch(lang, title=title)
        return res
