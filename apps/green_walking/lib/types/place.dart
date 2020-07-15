import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

class PlaceExtract {
  PlaceExtract({this.text, this.licenseShortName, this.licenseUrl});

  factory PlaceExtract.fromJson(Map<dynamic, dynamic> j) {
    return PlaceExtract(
      text: j['text'] as String,
      licenseShortName: j['licenseShortName'] as String,
      licenseUrl: j['licenseUrl'] as String,
    );
  }

  final String text;
  final String licenseShortName;
  final String licenseUrl;
}

class PlaceImage {
  PlaceImage(
      {this.artist,
      this.descriptionUrl,
      this.licenseShortName,
      this.licenseUrl,
      this.url});

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
      {this.aliases,
      this.categories,
      this.coordinateLocation,
      this.commonsUrl,
      this.description,
      this.extract,
      this.image,
      this.location,
      this.name,
      this.officialWebsite,
      @required this.wikidataId,
      this.wikipediaUrl})
      : assert(wikidataId != null);

  factory Place.fromJson(Map<dynamic, dynamic> j) {
    const String lang = 'de';
    String location = j['location'][lang]['location'] as String;
    final String locAdministrative =
        j['location'][lang]['administrative'] as String;
    if (locAdministrative != null) {
      if (location == null) {
        location = locAdministrative;
      } else {
        location = location + ', ' + locAdministrative;
      }
    }
    LatLng coordinateLocation;
    final double lat = j['coordinateLocation']['latitude'] as double;
    final double lng = j['coordinateLocation']['longitude'] as double;
    if (lat != null && lng != null) {
      coordinateLocation = LatLng(lat.toDouble(), lng.toDouble());
    }

    PlaceImage image;
    if (j['image'] != null) {
      image = PlaceImage.fromJson(j['image'] as Map<dynamic, dynamic>);
    }
    PlaceExtract extract;
    if (j['extract'] != null) {
      final Map<dynamic, dynamic> rawExtractLang =
          j['extract'][lang] as Map<dynamic, dynamic>;
      if (rawExtractLang != null) {
        extract = PlaceExtract.fromJson(rawExtractLang);
      }
    }

    return Place(
        aliases: List<String>.from(j['aliases'][lang] as List<dynamic>),
        categories: List<String>.from(j['categories'][lang] as List<dynamic>),
        coordinateLocation: coordinateLocation,
        commonsUrl: j['commonsUrl'] as String,
        description: j['description'] as String,
        extract: extract,
        image: image,
        location: location,
        name: j['name'][lang] as String,
        officialWebsite: j['officialWebsite'] as String,
        wikidataId: j['wikidataId'] as String,
        wikipediaUrl: j['wikipediaUrl'][lang] as String);
  }

  final List<String> aliases;
  final List<String> categories;
  final LatLng coordinateLocation;
  final String commonsUrl;
  final String description;
  final PlaceExtract extract;
  final PlaceImage image;
  final String location;
  final String name;
  final String officialWebsite;
  final String wikidataId;
  final String wikipediaUrl;
}
