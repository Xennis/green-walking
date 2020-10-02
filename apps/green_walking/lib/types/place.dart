import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:green_walking/types/language.dart';
import 'package:latlong/latlong.dart';

class PlaceExtract {
  PlaceExtract({
    @required this.text,
    @required this.url,
    @required this.licenseShortName,
    this.licenseUrl, // e.g. public domain has no url
    this.fallbackLang,
  }) : assert(text != null && url != null && licenseShortName != null);

  factory PlaceExtract.fromJson(
      Map<dynamic, dynamic> j, String url, Language fallbackLang) {
    return PlaceExtract(
        text: j['text'] as String,
        url: url,
        licenseShortName: j['licenseShortName'] as String,
        licenseUrl: j['licenseUrl'] as String,
        fallbackLang: fallbackLang);
  }

  final String text;
  final String url;
  final String licenseShortName;
  final String licenseUrl;
  final Language fallbackLang;
}

class PlaceImage {
  PlaceImage(
      {@required this.artist,
      @required this.descriptionUrl,
      @required this.licenseShortName,
      this.licenseUrl, // e.g. public domain has no URL
      @required this.url})
      : assert(artist != null &&
            descriptionUrl != null &&
            licenseShortName != null &&
            url != null);

  factory PlaceImage.fromJson(Map<dynamic, dynamic> j) {
    return PlaceImage(
      artist: j['artist'] as String,
      descriptionUrl: j['descriptionUrl'] as String,
      licenseShortName: j['licenseShortName'] as String,
      licenseUrl: j['licenseUrl'] as String,
      url: j['url'] as String,
    );
  }

  final String artist;
  final String descriptionUrl;
  final String licenseShortName;
  final String licenseUrl;
  final String url;
}

class Place {
  Place(
      {this.categories,
      this.geopoint,
      this.commonsUrl,
      this.description,
      this.extract,
      this.image,
      this.location,
      this.name,
      this.officialWebsite,
      this.type,
      @required this.wikidataId,
      this.wikipediaUrl})
      : assert(wikidataId != null);

  factory Place.fromFirestore(Map<dynamic, dynamic> j, Language language) {
    final String langStr = language.code.toLowerCase();
    final Language fallbackLang = (j['countryLanguage'] as List<dynamic>)
        .map((dynamic e) => languageFromString(e as String))
        .first;
    final String fallbackLangStr = fallbackLang.code.toLowerCase();

    String location = j['location'][langStr]['location'] as String;
    final String locAdministrative =
        j['location'][langStr]['administrative'] as String;
    if (locAdministrative != null) {
      if (location == null) {
        location = locAdministrative;
      } else {
        location = location + ', ' + locAdministrative;
      }
    }
    LatLng geopoint;
    final GeoPoint g = j['geopoint'] as GeoPoint;
    if (g?.latitude != null && g?.longitude != null) {
      geopoint = LatLng(g.latitude, g.longitude);
    }

    final String wikipediaUrl = j['wikipediaUrl'][langStr] as String;
    PlaceImage image;
    if (j['image'] != null) {
      image = PlaceImage.fromJson(j['image'] as Map<dynamic, dynamic>);
    }
    PlaceExtract extract;
    if (j['extract'] != null) {
      final Map<dynamic, dynamic> rawExtractLang =
          j['extract'][langStr] as Map<dynamic, dynamic>;
      if (rawExtractLang != null) {
        extract = PlaceExtract.fromJson(rawExtractLang, wikipediaUrl, null);
      } else if (language != fallbackLang) {
        final Map<dynamic, dynamic> rawFallbackExtractLang =
            j['extract'][fallbackLangStr] as Map<dynamic, dynamic>;

        extract = PlaceExtract.fromJson(rawFallbackExtractLang,
            j['wikipediaUrl'][fallbackLangStr] as String, fallbackLang);
      }
    }

    String name = j['name'][langStr] as String;
    if (name == null && language != fallbackLang) {
      name = j['name'][fallbackLangStr] as String;
    }

    return Place(
        //aliases: List<String>.from(j['aliases'][lang] as List<dynamic>),
        categories:
            List<String>.from(j['categories'][langStr] as List<dynamic>),
        geopoint: geopoint,
        commonsUrl: j['commonsUrl'] as String,
        description: j['description'] as String,
        extract: extract,
        image: image,
        location: location,
        name: name,
        officialWebsite: j['officialWebsite'] as String,
        type: j['type'] as String,
        wikidataId: j['wikidataId'] as String,
        wikipediaUrl: wikipediaUrl);
  }

  static const String TypeMonument = 'monument';
  static const String TypeNature = 'nature';

  //final List<String> aliases;
  final List<String> categories;
  final LatLng geopoint;
  final String commonsUrl;
  final String description;
  final PlaceExtract extract;
  final PlaceImage image;
  final String location;
  final String name;
  final String officialWebsite;
  final String type;
  final String wikidataId;
  final String wikipediaUrl;
}
