from typing import Dict, Any, Optional

from clients import WikipediaExtractClient
from core import fields


class FetchWikipedia:

    def __init__(self, client: WikipediaExtractClient):
        self._client = client

    def get_per_lang(self, wikidata_id: str, title_per_lang: Dict[str, Optional[str]]) -> Dict[str, Any]:
        res = {}
        for lang, title in title_per_lang.items():
            if not title:
                continue
            res[lang] = self._client.get(lang, title=title)

        return {
            fields.WIKIDATA_ID: wikidata_id,
            fields.ARTICLES: res
        }
