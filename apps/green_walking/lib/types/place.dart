import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

class PlaceImage {
  final String artist;
  final String descriptionUrl;
  final String licenseShortName;
  final String licenseUrl;
  final String url;

  PlaceImage(
      {this.artist,
      this.descriptionUrl,
      this.licenseShortName,
      this.licenseUrl,
      this.url});

  factory PlaceImage.fromJson(Map<dynamic, dynamic> j) {
    return PlaceImage(
      artist: j['artist'],
      descriptionUrl: j['descriptionUrl'],
      licenseShortName: j['licenseShortName'],
      licenseUrl: j['licenseUrl'],
      url: j['url'],
    );
  }
}

class Place {
  final List<String> aliases;
  final List<String> categories;
  final LatLng coordinateLocation;
  final String commonsUrl;
  final String description;
  final PlaceImage image;
  final String location;
  final String name;
  final String officialWebsite;
  final String wikidataId;
  final String wikipediaUrl;

  Place(
      {this.aliases,
      this.categories,
      this.coordinateLocation,
      this.commonsUrl,
      this.description,
      this.image,
      this.location,
      this.name,
      this.officialWebsite,
      @required this.wikidataId,
      this.wikipediaUrl})
      : assert(wikidataId != null);

  factory Place.fromJson(Map<dynamic, dynamic> j) {
    const String lang = 'de';
    String location = j['location'][lang]['location'];
    final String locAdministrative = j['location'][lang]['administrative'];
    if (locAdministrative != null) {
      if (location == null) {
        location = locAdministrative;
      } else {
        location = location + ', ' + locAdministrative;
      }
    }
    LatLng coordinateLocation;
    var lat = j['coordinateLocation']['latitude'];
    var lng = j['coordinateLocation']['longitude'];
    if (lat != null && lng != null) {
      coordinateLocation = LatLng(lat.toDouble(), lng.toDouble());
    }

    PlaceImage image;
    if (j['image'] != null) {
      image = PlaceImage.fromJson(j['image']);
    }

    return Place(
        aliases: List<String>.from(j['aliases'][lang]),
        categories: List<String>.from(j['categories'][lang]),
        coordinateLocation: coordinateLocation,
        commonsUrl: j['commonsUrl'],
        description: j['description'],
        image: image,
        location: location,
        name: j['name'][lang],
        officialWebsite: j['officialWebsite'],
        wikidataId: j['wikidataId'],
        wikipediaUrl: j['wikipediaUrl'][lang]);
  }
}
