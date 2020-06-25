from SPARQLWrapper import SPARQLWrapper, JSON


def get_results(endpoint_url, query):
    # User-Agent policy: https://w.wiki/CX6
    user_agent = "green-walking/0.1 (https://github.com/Xennis/green-walking)"
    sparql = SPARQLWrapper(endpoint_url, agent=user_agent)
    sparql.setQuery(query)
    sparql.setReturnFormat(JSON)
    return sparql.query().convert()


def main():
    endpoint_url = "https://query.wikidata.org/sparql"
    query = """\
    SELECT ?item WHERE {
      # item (instance of) p
      ?item wdt:P31 ?p;
        # item (country) Germany
        wdt:P17 wd:Q183 .
      # p in (park, botanical garden, green space, urban park, recreation area, landscape garden)
      FILTER (?p IN (wd:Q22698, wd:Q167346, wd:Q22652, wd:Q22746, wd:Q2063507, wd:Q15077303 ) )
    }"""
    results = get_results(endpoint_url, query)

    with open("all-parks.txt", "w") as f:
        for result in results["results"]["bindings"]:
            url = result["item"]["value"]
            items = url.rsplit("/", 1)[1]
            f.write(items + "\n")


if __name__ == "__main__":
    main()
