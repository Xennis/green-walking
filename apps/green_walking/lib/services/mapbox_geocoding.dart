library mapbox_geocoding;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class MaboxGeocodingPlace {
  MaboxGeocodingPlace({this.text, this.placeName, this.center});

  factory MaboxGeocodingPlace.fromJson(Map<String, dynamic> raw) {
    final List<dynamic> rawCenter = raw['center'] as List<dynamic>;
    LatLng center;
    if (rawCenter.length == 2) {
      final dynamic rawLat = rawCenter[1];
      final dynamic rawLng = rawCenter[0];
      center = LatLng(rawLat is int ? rawLat.toDouble() : rawLat as double,
          rawLng is int ? rawLng.toDouble() : rawLng as double);
    }
    return MaboxGeocodingPlace(
      text: raw['text'] as String,
      placeName: raw['place_name'] as String,
      center: center,
    );
  }

  final String text;
  final String placeName;
  final LatLng center;
}

class MapboxGeocodingResult {
  MapboxGeocodingResult({this.features, this.attribution});

  factory MapboxGeocodingResult.fromJson(Map<String, dynamic> raw) {
    final List<dynamic> features = raw['features'] as List<dynamic>;
    return MapboxGeocodingResult(
        features: features
            .map((dynamic e) => e as Map<String, dynamic>)
            .map((Map<String, dynamic> e) => MaboxGeocodingPlace.fromJson(e))
            .where((MaboxGeocodingPlace element) =>
                element.text != null &&
                element.placeName != null &&
                element.center != null)
            .toList(),
        attribution: raw['attribution'] as String);
  }

  final List<MaboxGeocodingPlace> features;
  final String attribution;
}

class MapboxGeocodingService implements Exception {
  MapboxGeocodingService(this.cause);
  String cause;
}

class MapboxGeocoding {
  static Future<MapboxGeocodingResult> get(
      String query, String token, LatLng loc) async {
    final Uri url = Uri.https('api.mapbox.com',
        '/geocoding/v5/mapbox.places/$query.json', <String, String>{
      'access_token': token,
      'limit': '5',
      'proximity': loc != null ? '${loc.longitude},${loc.latitude}' : ''
    });
    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return MapboxGeocodingResult.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw MapboxGeocodingService(
            'Invalid ${response.statusCode} response from API');
      }
    } on SocketException catch (_) {
      throw MapboxGeocodingService('No internet connection');
    }
  }
}
