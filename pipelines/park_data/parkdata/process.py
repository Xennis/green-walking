import logging
from typing import Dict, Any, Iterable, List, Optional
from bs4 import BeautifulSoup


class ProcessWikidata:

    @staticmethod
    def _resolve_commons_media(image_info: Dict[str, Any]) -> Dict[str, Any]:
        ext_meta_data = image_info.get("extmetadata", {})
        # It's safer to parse for False: It's better to wrongly assume a media has a copyright than the other way round.
        copyrighted = bool(ext_meta_data.get("Copyrighted", {}).get("value") != "False")
        artist = ext_meta_data.get("Artist", {}).get("value")
        # The artist attribute can contain a HTML link
        artist = None if artist is None else BeautifulSoup(artist, features="html.parser").text
        return {
            "artist": artist,
            "copyrighted": copyrighted,
            "descriptionUrl": image_info.get("descriptionurl"),
            "licenseShortName": ext_meta_data.get("LicenseShortName", {}).get("value"),
            "licenseUrl": ext_meta_data.get("LicenseUrl", {}).get("value"),
            "url": image_info.get("url"),
        }

    @staticmethod
    def _resolve_claims_by_type(claims: Dict[str, Iterable[Dict[str, Any]]]) -> Dict[str, Any]:
        res = {}
        for prop, values in claims.items():
            res[prop] = []
            for value in values:
                mainsnak = value.get("mainsnak", {})
                data_type = mainsnak.get("datatype")
                data_val = mainsnak.get("datavalue", {})
                data_val_type = data_val.get("type")

                if data_type == "string" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                elif data_type == "globe-coordinate" and data_val_type == "globecoordinate":
                    res[prop].append(data_val.get("value", {}))
                elif data_type == "wikibase-item" and data_val_type == "wikibase-entityid":
                    res[prop].append(data_val.get("gw", {}).get("labels", {}))
                elif data_type == "commonsMedia" and data_val_type == "string":
                    image_infos = data_val.get("gw", {}).get("imageinfo", [])
                    res[prop].append([ProcessWikidata._resolve_commons_media(info) for info in image_infos])
                elif data_type == "url" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                else:
                    logging.info("data_type %s and data_val_type %s not handled", data_type, data_val_type)
        return res

    @staticmethod
    def _create_categories(lang: str, instance_of: List[Dict[str, Any]], heritage_designation: List[Dict[str, Any]]) -> List[str]:
        res = []
        for category in instance_of + heritage_designation:
            label: Optional[str] = category.get(lang, {}).get("value")
            if not label:
                continue
            # Deduplicate labels. For example Q174782 (square) and Q22698 (park) have the same label in German.
            if label in res:
                continue
            res.append(label)
        return res

    def process(self, entry: Dict[str, Any]) -> Dict[str, Any]:
        aliases = entry.get("aliases", {})
        descriptions = entry.get("descriptions", {})
        labels = entry.get("labels", {})
        sitelinks = entry.get("sitelinks", {})

        claims = self._resolve_claims_by_type(entry.get("claims", {}))
        administrative = claims.get("located in the administrative territorial entity", [])
        coordinate_location: List[Dict[str, Any]] = claims.get("coordinate location", [])
        heritage_designation: List[Dict[str, Any]] = claims.get("heritage designation", [])
        instance_of: List[Dict[str, Any]] = claims.get("instance of", [])
        location = claims.get("location")
        officialWebsite = claims.get("official website")
        image = claims.get("image")

        return {
            "aliases": {
                "de": [e.get("value") for e in aliases.get("de", [])],
                "en": [e.get("value") for e in aliases.get("en", [])],
            },
            "categories": {
                "de": self._create_categories("de", instance_of, heritage_designation=heritage_designation),
                "en": self._create_categories("de", instance_of, heritage_designation=heritage_designation),
            },
            "coordinateLocation": {
                "latitude": coordinate_location[0].get("latitude") if coordinate_location else None,
                "longitude": coordinate_location[0].get("longitude") if coordinate_location else None
            },
            "commonsUrl": sitelinks.get("commonswiki", {}).get("url"),
            "descriptions": {
                "de": descriptions.get("de", {}).get("value"),
                "en": descriptions.get("en", {}).get("value")
            },
            "image": image[0][0] if image else None,
            "location": {
                "de": {
                    "location": location[0].get("de", {}).get("value") if location else None,
                    "administrative": administrative[0].get("de", {}).get("value") if administrative else None
                },
                "en": {
                    "location": location[0].get("en", {}).get("value") if location else None,
                    "administrative": administrative[0].get("en", {}).get("value") if administrative else None
                },
            },
            "name": {
                "de": labels.get("de", {}).get("value"),
                "en": labels.get("en", {}).get("value"),
            },
            "officialWebsite": officialWebsite[0] if officialWebsite else None,
            "wikidataId": entry.get("title"),
            "wikipediaUrl": {
                "de": sitelinks.get("dewiki", {}).get("url"),
                "en": sitelinks.get("enwiki", {}).get("url")
            },
        }
