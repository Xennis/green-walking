import json,urllib.request
import logging
from typing import Dict, List, Any


chache = {}


def request_entity_data(entity: str) -> Dict[str, Any]:
    req = urllib.request.Request(f"https://www.wikidata.org/wiki/Special:EntityData/{entity}.json")
    req.add_header("User-Agent", "green-walking/0.1 (https://github.com/Xennis/green-walking)")
    raw = urllib.request.urlopen(req).read()
    data = json.loads(raw)
    try:
        entry = data["entities"][entity]
    except KeyError:
        # A known case that happens: Redirects.
        logging.warning(f"entity {entity} not found in entry")
        entry = data["entities"][0]
    return entry


def get_mainsnak_id(claims: Dict[str, Any], prop: str) -> List[Any]:
    return [instance_of.get("mainsnak", {}).get("datavalue", {}).get("value", {}).get("id") for instance_of in claims.get(prop, [{}])]


def chached_or_request_entity_data(entity: str) -> Dict[str, Any]:
    if entity in chache:
        return chache.get(entity)

    labels = request_entity_data(entity).get("labels", {})
    val = {
        "_id": entity,
        "de": labels.get("de", {}).get("value"),
        "en": labels.get("en", {}).get("value"),
    }
    chache[entity] = val
    return val


def resolve_claims(claims: Dict[str, List[Dict[str, Any]]]) -> Dict[str, Any]:
    result = {}
    for prop, values in claims.items():
        name = chached_or_request_entity_data(prop)["en"]
        if name is None:
            logging.warning("label for entity %s is none", prop)
            continue

        result[name] = []
        for value in values:
            data_val = value.get("mainsnak", {}).get("datavalue", {})
            data_val_type = data_val.get("type")
            if data_val_type == "string":
                result[name].append(data_val.get("value"))
            elif data_val_type == "wikibase-entityid":
                id = data_val.get("value", {}).get("id")
                if id is None:
                    logging.warning("datalue.value has no ID: %s", data_val)
                    continue
                id_name = chached_or_request_entity_data(id)
                # if id_name is None:
                #     continue
                result[name].append(id_name)
            elif data_val_type in ["globecoordinate", "time", "quantity", "monolingualtext"]:
                result[name].append(data_val.get("value", {}))
            else:
                logging.warning("data_val_type is %s", data_val_type)
                result[name].append(data_val.get("value", {}))
    return result


def extract_information(entry: Dict[str, Any]) -> Dict[str, Any]:
    result = {}
    # TODO: Save entity ID
    result["labels"] = {
        "de": entry.get("labels", {}).get("de", {}).get("value"),
        "en": entry.get("labels", {}).get("en", {}).get("value"),
    }
    result["aliases"] = {
        "de": [e.get("value") for e in entry.get("aliases", {}).get("de", [])],
        "en": [e.get("value") for e in entry.get("aliases", {}).get("en", [])],
    }
    result["descriptions"] = {
        "de": entry.get("descriptions", {}).get("de", {}).get("value"),
        "en": entry.get("descriptions", {}).get("en", {}).get("value")
    }
    result["claims"] = resolve_claims(entry.get("claims", {}))
    result["wiki_url"] = {
        "de": entry.get("sitelinks", {}).get("dewiki", {}).get("url"),
        "en": entry.get("sitelinks", {}).get("enwiki", {}).get("url")
    }

    # Store all data that was not parsed above to might find some more interesting fields.
    if "labels" in entry:
        del entry["labels"]
    if "descriptions" in entry:
        del entry["descriptions"]
    if "claims" in entry:
        del entry["claims"]
    if "sitelinks" in entry:
        del entry["sitelinks"]
    if "aliases" in entry:
        del entry["aliases"]
    result["remaining"] = entry

    return result


def main() -> None:
    parsed = []
    with open("all-parks.txt") as f:
        for line in f:
            try:
                entity_data = request_entity_data(line.rstrip("\n"))
                parsed.append(extract_information(entity_data))
            except Exception as e:
                logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")

    with open("park-details.json", "w") as f:
        for p in parsed:
            f.write(json.dumps(p) + "\n")


if __name__ == "__main__":
    main()
