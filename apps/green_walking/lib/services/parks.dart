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
    LineSplitter()
        .convert(rawBlob)
        .map((line) => Place.fromJson(json.decode(line)))
        .forEach((p) {
      if (p.coordinateLocation == null) {
        return;
      }
      places[p.coordinateLocation] = p;
    });
    return places.values;
  }

  static Place get(LatLng location) {
    return places[location];
  }
}
