import logging
from typing import Dict, Any, Iterable, List
from bs4 import BeautifulSoup


class ProcessWikidata:

    # @staticmethod
    # def _resolve_commons_media(image_info: Dict[str, Any]) -> Dict[str, Any]:
    #     res = {}
    #     res["url"] = image_info.get("url")
    #     res["description_url"] = image_info.get("descriptionurl")
    #
    #     ext_meta_data = image_info.get("extmetadata", {})
    #     res["license_short_name"] = ext_meta_data.get("LicenseShortName", {}).get("value")
    #     res["license_url"] = ext_meta_data.get("LicenseUrl", {}).get("value")
    #     res["copyrighted"] = bool(
    #         ext_meta_data.get("Copyrighted", {}).get("value") != "False")  # Safer to parse for False than True
    #     artist = ext_meta_data.get("Artist").get("value")
    #     if artist is not None:
    #         # Remove the HTML link is there is one
    #         res["artist"] = BeautifulSoup(artist, features="html.parser").text
    #     else:
    #         res["artist"] = None
    #     return res

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
                    # TODO: Resolve media
                    res[prop].append(image_infos)
                elif data_type == "url" and data_val_type == "string":
                    res[prop].append(data_val.get("value"))
                else:
                    logging.info("data_type %s and data_val_type %s not handled", data_type, data_val_type)
        return res

    def process(self, entry: Dict[str, Any]) -> Dict[str, Any]:
        aliases = entry.get("aliases", {})
        descriptions = entry.get("descriptions", {})
        labels = entry.get("labels", {})
        sitelinks = entry.get("sitelinks", {})

        claims = self._resolve_claims_by_type(entry.get("claims", {}))
        administrative = claims.get("located in the administrative territorial entity", [])
        coordinate_location: List[Dict[str, Any]] = claims.get("coordinate location", {})
        heritage_designation: List[Dict[str, Any]] = claims.get("heritage designation", {})
        instance_of: List[Dict[str, Any]] = claims.get("instance of", {})
        location = claims.get("location")
        image = claims.get("image")

        return {
            "aliases": {
                "de": [e.get("value") for e in aliases.get("de", [])],
                "en": [e.get("value") for e in aliases.get("en", [])],
            },
            "coordinate location": {
                "latitude": coordinate_location[0].get("latitude") if coordinate_location else None,
                "longitude": coordinate_location[0].get("longitude") if coordinate_location else None
            },
            "categories": {
                "de": [v.get("de", {}).get("value") for v in instance_of] + [v.get("de", {}).get("value") for v in heritage_designation],
                "en": [v.get("en", {}).get("value") for v in instance_of] + [v.get("en", {}).get("value") for v in heritage_designation],
            },
            "descriptions": {
                "de": descriptions.get("de", {}).get("value"),
                "en": descriptions.get("en", {}).get("value")
            },
            "image": image,
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
            "wikipedia_url": {
                "de": sitelinks.get("dewiki", {}).get("url"),
                "en": sitelinks.get("enwiki", {}).get("url")
            },
            "commons_url": sitelinks.get("commonswiki", {}).get("url"),
            "wikidata_id": entry.get("title"),
        }
