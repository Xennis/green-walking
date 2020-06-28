import json
import urllib.request
import urllib.parse
from typing import Dict, Any, Iterable


class CommonsImageInfoClient:
    """Wikimedia Commons client using the Imageinfo API of the MediaWiki API."""

    _API_ENDPOINT = "https://commons.wikimedia.org/w/api.php"
    _NAMESPACE_FILE = "File"

    def __init__(self, user_agent: str):
        self._user_agent = user_agent

    def _do_request(self, names: Iterable[str]) -> Dict[str, Any]:
        """
        API documentation: https://www.mediawiki.org/wiki/API:Imageinfo

        Example: https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=imageinfo&titles=<title>&iiprop=url|extmetadata&iimetadataversion=latest
        """
        titles = [f"{self._NAMESPACE_FILE}:{name}" for name in names]
        iiprop = [
            "url",
            "extmetadata"  # API documentation: https://www.mediawiki.org/wiki/Extension:CommonsMetadata#Usage
        ]
        params = urllib.parse.urlencode({
            "action": "query",
            "format": "json",
            "prop": "imageinfo",
            "titles": "|".join(titles),
            "iiprop": "|".join(iiprop),
            "maxlag": 2,  # Lag in seconds. Recommended for non interactive requests by https://www.mediawiki.org/wiki/API:Etiquette
        })
        req = urllib.request.Request(f"{CommonsImageInfoClient._API_ENDPOINT}?{params}")
        req.add_header("User-Agent", self._user_agent)
        resp = urllib.request.urlopen(req).read()
        return json.loads(resp)

    def get(self, name: str) -> Dict[str, Dict[str, Any]]:
        resp = self._do_request([name])
        pages: Dict[str, Any] = resp["query"]["pages"]
        for page in pages.values():
            return page
