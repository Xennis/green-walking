import json
import logging
import os.path

from clients import WikidataQueryClient, WikidataEntityClient, CommonsImageInfoClient, WikipediaExtractClient
from parkdata import FetchWikidata, ProcessWikidata
from core import fields
from parkextract import FetchWikipedia, ProcessWikipedia


def main():
    # User-Agent policy: https://w.wiki/CX6
    user_agent = "green-walking/0.1 (https://github.com/Xennis/green-walking)"

    file_wikidata_list = "all-parks.txt"
    file_wikidata_details = "park-details.json"
    file_parks = "parks.json"
    file_wikipedia_articles = "wikipedia-articles.json"
    file_wikipedia_details = "wikipedia-details.json"
    file_parks_enriched = "parks-enriched.json"

    if not os.path.exists(file_wikidata_list):
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
        with open(file_wikidata_list, "w") as f:
            for entity_id in entity_ids:
                f.write(entity_id + "\n")

    if not os.path.exists(file_wikidata_details):
        client = FetchWikidata(wikidata_client=WikidataEntityClient(user_agent), commons_client=CommonsImageInfoClient(user_agent))
        with open(file_wikidata_list) as f_in:
            with open(file_wikidata_details, "w") as f_out:
                for line in f_in:
                    try:
                        entity_data = client.get(line.rstrip("\n"))
                    except Exception as e:
                        logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                        continue
                    f_out.write(json.dumps(entity_data, sort_keys=True) + "\n")

    process = ProcessWikidata()
    with open(file_wikidata_details) as f_in:
        with open(file_parks, "w") as f_out:
            for line in f_in:
                raw = json.loads(line.rstrip("\n"))
                try:
                    entity_data = process.process(raw)
                except Exception as e:
                    logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                    continue
                f_out.write(json.dumps(entity_data, sort_keys=True) + "\n")

    if not os.path.exists(file_wikipedia_articles):
        client = FetchWikipedia(WikipediaExtractClient(user_agent))
        with open(file_parks) as f_in:
            with open(file_wikipedia_articles, "w") as f_out:
                for line in f_in:
                    raw = json.loads(line.rstrip("\n"))
                    title_per_lang = {}
                    for lang, entry in raw.get(fields.WIKIPEDIA, {}).items():
                        title_per_lang[lang] = entry.get(fields.TITLE)
                    try:
                        article_data = client.get_per_lang(raw.get(fields.WIKIDATA_ID), title_per_lang)
                    except Exception as e:
                        logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                        continue
                    f_out.write(json.dumps(article_data, sort_keys=True) + "\n")

    if not os.path.exists(file_wikipedia_details):
        process = ProcessWikipedia()
        with open(file_wikipedia_articles) as f_in:
            with open(file_wikipedia_details, "w") as f_out:
                for line in f_in:
                    raw = json.loads(line.rstrip("\n"))
                    try:
                        article_data = process.process(raw)
                    except Exception as e:
                        logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                        continue
                    if not article_data:
                        continue
                    f_out.write(json.dumps(article_data, sort_keys=True) + "\n")

    if True:
        wikipedia_articles = {}
        with open(file_wikipedia_details) as f:
            for line in f:
                raw = json.loads(line.rstrip("\n"))
                wikipedia_articles[raw.get(fields.WIKIDATA_ID)] = raw.get(fields.ARTICLES)

        with open(file_parks) as f_in:
            with open(file_parks_enriched, "w") as f_out:
                for line in f_in:
                    raw = json.loads(line.rstrip("\n"))
                    wikidata_id = raw.get(fields.WIKIDATA_ID)
                    urls_per_lang = {}
                    for lang, entry in raw.get(fields.WIKIPEDIA, {}).items():
                        urls_per_lang[lang] = entry.get(fields.URL)

                    del raw[fields.WIKIPEDIA]
                    raw["wikipediaUrl"] = urls_per_lang
                    try:
                        raw["extract"] = wikipedia_articles.get(wikidata_id)
                    except Exception as e:
                        logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")
                        continue

                    coordinateLoc = raw.get(fields.COORDINATE_LOCATION)
                    latitude = coordinateLoc.get(fields.LATITUDE)
                    if not latitude:
                        logging.info(f"Skipped {wikidata_id} because it has no latitude")
                        continue
                    longitude = coordinateLoc.get(fields.LONGITUDE)
                    if not longitude:
                        logging.info(f"Skipped {wikidata_id} because it has no longitude")
                        continue
                    raw[fields.COORDINATE_LOCATION] = {
                        # The latitude/longitude fields in the app are loaded as double. At this point it can be an
                        # integer (e.g. 9 instead of 9.0).
                        fields.LATITUDE: float(latitude),
                        fields.LONGITUDE: float(longitude),
                    }

                    f_out.write(json.dumps(raw, sort_keys=True) + "\n")


if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    main()
