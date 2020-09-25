import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class MaboxGeocordingPlace {
  MaboxGeocordingPlace({this.text, this.placeName, this.center});

  factory MaboxGeocordingPlace.fromJson(Map<String, dynamic> raw) {
    final List<dynamic> rawCenter = raw['center'] as List<dynamic>;
    LatLng center;
    if (rawCenter.length == 2) {
      final dynamic rawLat = rawCenter[1];
      final dynamic rawLng = rawCenter[0];
      center = LatLng(rawLat is int ? rawLat.toDouble() : rawLat as double,
          rawLng is int ? rawLng.toDouble() : rawLng as double);
    }
    return MaboxGeocordingPlace(
      text: raw['text_de'] as String,
      placeName: raw['place_name_de'] as String,
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
            .map((Map<String, dynamic> e) => MaboxGeocordingPlace.fromJson(e))
            .where((MaboxGeocordingPlace element) =>
                element.text != null &&
                element.placeName != null &&
                element.center != null)
            .toList(),
        attribution: raw['attribution'] as String);
  }

  final List<MaboxGeocordingPlace> features;
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
      'language': 'de',
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
            'Keine Verbindung zum Suchserver (Code: ${response.statusCode})');
      }
    } on SocketException catch (_) {
      throw MapboxGeocodingService('Keine Internetverbindung');
    }
  }
}
