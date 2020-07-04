import json
import logging
import os.path
from clients import WikidataQueryClient, WikidataEntityClient, CommonsImageInfoClient
from parkdata import FetchWikidata, ProcessWikidata


def main():
    # User-Agent policy: https://w.wiki/CX6
    user_agent = "green-walking/0.1 (https://github.com/Xennis/green-walking)"

    file_all_parks = "all-parks.txt"
    file_park_details = "park-details.json"
    file_parks = "parks.json"

    if not os.path.exists(file_all_parks):
        query = """\
            SELECT ?item WHERE {
              # item (instance of) p
              ?item wdt:P31 ?p;
                # item (country) Germany
                wdt:P17 wd:Q183 .
              # p in (park, botanical garden, green space, urban park, recreation area, landscape garden)
              FILTER (?p IN (wd:Q22698, wd:Q167346, wd:Q22652, wd:Q22746, wd:Q2063507, wd:Q15077303 ) )
            }"""
        client = WikidataQueryClient(user_agent)
        entity_ids = client.sparql(query)
        with open(file_all_parks, "w") as f:
            for entity_id in entity_ids:
                f.write(entity_id + "\n")

    if not os.path.exists(file_park_details):
        client = FetchWikidata(wikidata_client=WikidataEntityClient(user_agent), commons_client=CommonsImageInfoClient(user_agent))
        with open(file_all_parks) as f_in:
            with open(file_park_details, "w") as f_out:
                for line in f_in:
                    try:
                        entity_data = client.get(line.rstrip("\n"))
                    except Exception as e:
                        logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                        continue
                    f_out.write(json.dumps(entity_data, sort_keys=True) + "\n")

    process = ProcessWikidata()
    with open(file_park_details) as f_in:
        with open(file_parks, "w") as f_out:
            for line in f_in:
                raw = json.loads(line.rstrip("\n"))
                try:
                    entity_data = process.process(raw)
                except Exception as e:
                    logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                    continue
                f_out.write(json.dumps(entity_data, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
