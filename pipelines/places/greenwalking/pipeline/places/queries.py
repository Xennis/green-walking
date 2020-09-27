from typing import Tuple, List

from greenwalking.core import country
from greenwalking.pipeline.places.ctypes import Typ, TYP_PARK, TYP_MONUMENT, TYP_NATURE


def wd_queries() -> List[Tuple[Tuple[country.Country, Typ], str]]:
    # For coordinate examples see https://en.wikibooks.org/wiki/SPARQL/WIKIDATA_Precision,_Units_and_Coordinates#Coordinates
    return [
        (
            (country.GERMANY, TYP_PARK),
            """\
SELECT ?item WHERE {
    # item (instance of) p
    ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183 .
    # p in (park, botanical garden, green space, urban park, recreation area, landscape garden)
    FILTER (?p IN (wd:Q22698, wd:Q167346, wd:Q22652, wd:Q22746, wd:Q2063507, wd:Q15077303 ) )
}""",
        ),
        (
            (country.GERMANY, TYP_MONUMENT),
            """\
SELECT DISTINCT ?item WHERE {
    # item (instance of) p
    ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183;
        # item (coordinate location) coordinate
        wdt:P625 ?coordinate.
    # item "has site links"
    ?article schema:about ?item;
        schema:isPartOf ?sitelink.
    # p in (natural monument in Germany)
    FILTER(?p IN(wd:Q21573182))
}""",
        ),
        (
            (country.GERMANY, TYP_NATURE),
            """\
SELECT DISTINCT ?item WHERE {
    # item (instance of) p
    ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183;
        # item (coordinate location) coordinate
        wdt:P625 ?coordinate.
    # item "has site links"
    ?article schema:about ?item;
        schema:isPartOf ?sitelink.
    # p in (nature reserve in Germany)
    FILTER(?p IN(wd:Q759421))
}""",
        ),
    ]
