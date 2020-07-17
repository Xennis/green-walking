import copy
import json
import urllib.request
import urllib.parse
from typing import Dict, Any, Iterable, Optional


class CommonsImageInfoClient:
    """Wikimedia Commons client using the Imageinfo API of the MediaWiki API."""

    _API_ENDPOINT = "https://commons.wikimedia.org/w/api.php"
    _NAMESPACE_FILE = "File"

    def __init__(self, user_agent: str):
        self._user_agent = user_agent

    def _do_request(self, titles: Iterable[str]) -> Dict[str, Any]:
        """
        API documentation: https://www.mediawiki.org/wiki/API:Imageinfo

        Example: https://commons.wikimedia.org/w/api.php?action=query&format=json&titles=File:Jenisch-Panorama-1200px.jpg&prop=imageinfo&iiprop=url|extmetadata&iimetadataversion=latest
        """
        iiprop = ["url", "extmetadata"]  # API documentation: https://www.mediawiki.org/wiki/Extension:CommonsMetadata#Usage
        params = urllib.parse.urlencode(
            {
                "action": "query",
                "format": "json",
                "iiprop": "|".join(iiprop),
                "maxlag": 2,  # Lag in seconds. Recommended for non interactive requests by https://www.mediawiki.org/wiki/API:Etiquette
                "prop": "imageinfo",
                "titles": "|".join(titles),
            }
        )
        req = urllib.request.Request(f"{self._API_ENDPOINT}?{params}")
        req.add_header("User-Agent", self._user_agent)
        resp = urllib.request.urlopen(req).read()
        return json.loads(resp)

    def get(self, name: str) -> Dict[str, Dict[str, Any]]:
        title = f"{self._NAMESPACE_FILE}:{name}"
        resp = self._do_request([title])
        pages: Dict[str, Any] = resp["query"]["pages"]
        for page in pages.values():
            return page
        raise Exception("Nothing returned")


class WikipediaExtractClient:

    _API_ENDPOINT_TEMPLATE = "https://{lang}.wikipedia.org/w/api.php"

    def __init__(self, user_agent: str):
        self._user_agent = user_agent

    def _do_request(self, lang: str, titles: Iterable[str]) -> Dict[str, Any]:
        """
        API documentation: https://www.mediawiki.org/wiki/Extension:TextExtracts#API

        Example: https://de.wikipedia.org/w/api.php?action=query&format=json&titles=Jenischpark&prop=extracts&exintro&explaintext&redirects=1
        """
        endpoint = self._API_ENDPOINT_TEMPLATE.replace("{lang}", lang, 1)
        params = urllib.parse.urlencode(
            {
                "action": "query",
                "exintro": 1,  # Return only content before the first section.
                "explaintext": 1,  # Return extracts as plain text instead of limited HTML.
                "format": "json",
                "maxlag": 2,  # Lag in seconds. Recommended for non interactive requests by https://www.mediawiki.org/wiki/API:Etiquette
                "prop": "extracts",
                "redirects": 1,  # Follow redirects
                "titles": "|".join(titles),
                # API documentation: https://www.mediawiki.org/wiki/API:Siteinfo
                "meta": "siteinfo",
                "siprop": "|".join(["rightsinfo"]),
            }
        )
        req = urllib.request.Request(f"{endpoint}?{params}")
        req.add_header("User-Agent", self._user_agent)
        resp = urllib.request.urlopen(req).read()
        return json.loads(resp)

    def get(self, lang: str, title: str) -> Dict[str, Dict[str, Any]]:
        """
        API documentation: https://www.mediawiki.org/wiki/Extension:TextExtracts#API

        Example: https://de.wikipedia.org/w/api.php?action=query&format=json&titles=Jenischpark&prop=extracts&exintro&explaintext&redirects=1
        """
        resp = self._do_request(lang=lang, titles=[title])
        query: Dict[str, Dict[str, Any]] = resp["query"]
        pages: Dict[str, Any] = query["pages"]
        for page in pages.values():
            page["rightsinfo"] = query["rightsinfo"]
            return page
        raise Exception("Nothing returned")
