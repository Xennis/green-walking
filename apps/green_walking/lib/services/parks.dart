import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';

import '../types/place.dart';

Map<LatLng, Place> places = <LatLng, Place>{};

class ParkService {
  static Future<Iterable<Place>> load(BuildContext context) async {
    final String rawBlob =
        await DefaultAssetBundle.of(context).loadString('assets/parks.json');
    const LineSplitter()
        .convert(rawBlob)
        .map((String line) =>
            Place.fromJson(json.decode(line) as Map<dynamic, dynamic>))
        .forEach((Place p) {
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
