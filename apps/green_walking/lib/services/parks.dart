import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';
import 'dart:convert';

import '../types/place.dart';

Map<LatLng, Place> places = Map();

class ParkService {
  static Future<Iterable<Place>> load(BuildContext context) async {
    String rawBlob =
        await DefaultAssetBundle.of(context).loadString("assets/parks.json");
    List<String> rawLines = LineSplitter().convert(rawBlob);

    for (var i = 0; i < rawLines.length; i++) {
      Place p = Place.fromJson(json.decode(rawLines[i]));
      if (p.coordinateLocation == null) {
        continue;
      }
      places[p.coordinateLocation] = p;
    }
    return places.values;
  }

  static Place get(LatLng location) {
    return places[location];
  }
}
