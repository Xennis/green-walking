import 'dart:async';

import 'package:async/async.dart' show FutureGroup;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:green_walking/types/language.dart';
import 'package:latlong/latlong.dart';

import '../types/place.dart';

Map<LatLng, Place> places = <LatLng, Place>{};

Future<List<Place>> nearbyPlaces(GeoHash centerHash, Language lang) {
  final Iterable<String> area = centerHash.neighbors.values.toList()
    ..add(centerHash.toString());

  final Iterable<Future<Iterable<Place>>> queries = area.map((String hash) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('places_v4')
        .orderBy('geohash')
        .startAt(<String>[hash]).endAt(<String>[hash + '~']);
    return query.get().then((QuerySnapshot<Map<String, dynamic>> value) {
      return value.docs.map((DocumentSnapshot<Map<String, dynamic>> e) =>
          Place.fromFirestore(e.data(), lang));
    });
  });

  final FutureGroup<Iterable<Place>> fg = FutureGroup<Iterable<Place>>();
  // ignore: avoid_function_literals_in_foreach_calls
  queries.forEach((Future<Iterable<Place>> element) {
    fg.add(element);
  });

  fg.close();
  return fg.future.then((List<Iterable<Place>> value) {
    final List<Place> flatten = value.expand((Iterable<Place> e) => e).toList();
    return flatten;
    //const Distance distance = Distance();
    //return flatten.where((Place place) {
    //  final num dis =
    //      distance.as(LengthUnit.Kilometer, center, place.geopoint);
    //  return dis <= 39 * 1.02; // buffer for edge
    //}).toList();
  });
}
