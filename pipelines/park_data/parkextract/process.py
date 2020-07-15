from typing import Dict, Any, Optional

from core import fields


class ProcessWikipedia:

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
        rightinfo: Optional[Dict[str, Any]] = article_data.get("rightsinfo", {})

        return {
            fields.TEXT: extract.strip() if extract else None,
            fields.LICENSE_URL: ProcessWikipedia._fix_protocol_relative_url_for_rightsinfo(rightinfo.get("url")),
            fields.LICENSE_SHORT_NAME: ProcessWikipedia._shorten_licence_name(rightinfo.get("text")),
        }

    def process(self, entry: Dict[str, Dict[str, Any]]) -> Optional[Dict[str, Dict[str, Any]]]:
        res = {}
        for lang, article_data in entry.get(fields.ARTICLES, {}).items():
            res[lang] = self._resolve_article_data(article_data)

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
        return {
            fields.WIKIDATA_ID: entry.get(fields.WIKIDATA_ID),
            fields.ARTICLES: filtered
        }
