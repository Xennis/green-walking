library mapbox_geocoding;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show Position;

class MaboxGeocodingPlace {
  MaboxGeocodingPlace({this.text, this.placeName, this.center});

  factory MaboxGeocodingPlace.fromJson(Map<String, dynamic> raw) {
    final List<dynamic>? rawCenter = raw['center'] as List<dynamic>?;
    Position? center;
    if (rawCenter != null && rawCenter.length == 2) {
      final dynamic rawLat = rawCenter[1];
      final dynamic rawLng = rawCenter[0];
      center = Position(rawLng is int ? rawLng.toDouble() : rawLng as double,
          rawLat is int ? rawLat.toDouble() : rawLat as double);
    }
    return MaboxGeocodingPlace(
      text: raw['text'] as String?,
      placeName: raw['place_name'] as String?,
      center: center,
    );
  }

  final String? text;
  final String? placeName;
  final Position? center;
}

class MapboxGeocodingResult {
  MapboxGeocodingResult(this.features, {this.attribution});

  factory MapboxGeocodingResult.fromJson(Map<String, dynamic> raw) {
    final List<dynamic> features =
        raw['features'] as List<dynamic>? ?? <dynamic>[];
    return MapboxGeocodingResult(
        features
            .map((dynamic e) => e as Map<String, dynamic>)
            .map((Map<String, dynamic> e) => MaboxGeocodingPlace.fromJson(e))
            .where((MaboxGeocodingPlace element) =>
                element.text != null &&
                element.placeName != null &&
                element.center != null)
            .toList(),
        attribution: raw['attribution'] as String?);
  }

  final List<MaboxGeocodingPlace> features;
  final String? attribution;
}

class MapboxGeocodingService implements Exception {
  MapboxGeocodingService(this.cause);
  String cause;
}

Future<MapboxGeocodingResult> _mapboxGeocoding(
    String query, String token, Map<String, String> params) async {
  final Uri url = Uri.https(
      'api.mapbox.com', '/geocoding/v5/mapbox.places/$query.json', params);
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

// Note For debugging https://docs.mapbox.com/playground/geocoding/ is helpful
Future<MapboxGeocodingResult> mapboxForwardGeocoding(String query, String token,
    {Position? proximity, int limit = 5}) async {
  final Map<String, String> params = <String, String>{
    'access_token': token,
    'limit': limit.toString(),
  };
  if (proximity != null) {
    params['proximity'] = _mapboxPositionToString(proximity);
  }
  return _mapboxGeocoding(query, token, params);
}

// Note For debugging https://docs.mapbox.com/playground/geocoding/ is helpful
// Consider improving it: https://nominatim.openstreetmap.org/ui/reverse.html
Future<MapboxGeocodingResult> mapboxReverseGeocoding(
    Position query, String token,
    {int limit = 1}) async {
  final Map<String, String> params = <String, String>{
    'access_token': token,
    // Not included: country,region,postcode,district,locality,neighborhood,place,poi
    'types': 'address',
    // If multiple types are set the limit must not be set.
    'limit': limit.toString(),
  };
  return _mapboxGeocoding(_mapboxPositionToString(query), token, params);
}

String _mapboxPositionToString(Position position, {int fractionDigits = 6}) {
  return '${position.lng.toStringAsFixed(fractionDigits)},${position.lat.toStringAsFixed(fractionDigits)}';
}
