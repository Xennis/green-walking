import json
import logging
from typing import Dict, Any


def extract_item_data(entry: Dict[str, Any]) -> Dict[str, Any]:
    res = {}
    res["name"] = entry.get("labels", {}).get("de")
    res["aliases"] = entry.get("aliases")["de"]
    res["description"] = entry.get("descriptions", {}).get("de")
    res["wiki_url"] = entry.get("wiki_url", {}).get("de")

    claims = entry.get("claims", {})
    location = claims.get("location")
    administrative = claims.get("located in the administrative territorial entity", [])
    res["location"] = {
        "location": location[0].get("de") if location else None,
        "administrative": administrative[0].get("de") if administrative else None
    }
    coordinate_location = claims.get("coordinate location")
    res["coordinate location"] = {
        "latitude": coordinate_location[0].get("latitude") if coordinate_location else None,
        "longitude": coordinate_location[0].get("longitude") if coordinate_location else None
    }
    res["categories"] = [v.get("de") for v in claims.get("instance of")] + [v.get("de") for v in claims.get("heritage designation", {})]
    return res


def main() -> None:
    parsed = []
    with open("park-details.json") as f:
        for line in f:
            try:
                item = line.rstrip("\n")
                parsed.append(extract_item_data(json.loads(item)))
            except Exception as e:
                logging.warning(f"failed to parse line '{e}' of {type(e).__name__}:\n{line}")

    with open("parks.json", "w") as f:
        for p in parsed:
            f.write(json.dumps(p) + "\n")


if __name__ == "__main__":
    main()
