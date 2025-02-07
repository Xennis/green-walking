library mapbox_geocoding;

import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show Position, MapboxOptions;

import '../config.dart';

class GeocodingPlace {
  GeocodingPlace({this.text, this.placeName, this.center, this.url});

  factory GeocodingPlace.fromMapboxJson(Map<String, dynamic> raw) {
    final List<dynamic>? rawCenter = raw['center'] as List<dynamic>?;
    Position? center;
    if (rawCenter != null && rawCenter.length == 2) {
      final dynamic rawLat = rawCenter[1];
      final dynamic rawLng = rawCenter[0];
      center = Position(
          rawLng is int ? rawLng.toDouble() : rawLng as double, rawLat is int ? rawLat.toDouble() : rawLat as double);
    }
    return GeocodingPlace(
      text: raw['text'] as String?,
      placeName: raw['place_name'] as String?,
      center: center,
    );
  }

  factory GeocodingPlace.fromOsmJson(Map<String, dynamic> raw) {
    Position? center;
    try {
      center = Position(double.parse(raw['lon']), double.parse(raw['lat']));
    } catch (e) {
      log('failed to parse position: $e');
    }

    final int placeId = raw['place_id'] as int;
    final String? type = raw['type'] as String?;
    final String? name = raw['name'] as String?;
    final Uri url =
        Uri.https('nominatim.openstreetmap.org', '/ui/details.html', <String, String>{'place_id': placeId.toString()});

    return GeocodingPlace(
      text: name != null && name.isNotEmpty ? name : type,
      placeName: raw['display_name'] as String?,
      center: center,
      url: url,
    );
  }

  final String? text;
  final String? placeName;
  final Position? center;
  final Uri? url;
}

class GeocodingResult {
  GeocodingResult(this.features, {required this.attribution});

  factory GeocodingResult.fromMapboxJson(Map<String, dynamic> raw) {
    final List<dynamic> features = raw['features'] as List<dynamic>? ?? <dynamic>[];
    final String attribution = (raw['attribution'] as String).replaceFirst('NOTICE: ', '');

    return GeocodingResult(
        features
            .map((dynamic e) => e as Map<String, dynamic>)
            .map((Map<String, dynamic> e) => GeocodingPlace.fromMapboxJson(e))
            .where((element) => element.text != null && element.placeName != null && element.center != null)
            .toList(),
        attribution: attribution);
  }

  factory GeocodingResult.fromOsmJson(Map<String, dynamic> raw) {
    final List<GeocodingPlace> features = [GeocodingPlace.fromOsmJson(raw)];
    final String attribution = (raw['licence'] as String).replaceFirst('Data ', '');

    return GeocodingResult(
        features
            .where((element) => element.text != null && element.placeName != null && element.center != null)
            .toList(),
        attribution: attribution);
  }

  final List<GeocodingPlace> features;
  final String attribution;
}

class GeocodingServiceException implements Exception {
  GeocodingServiceException(this.cause);
  String cause;
}

Future<GeocodingResult> _mapboxGeocoding(String query, Map<String, String> params) async {
  final Uri url = Uri.https('api.mapbox.com', '/geocoding/v5/mapbox.places/$query.json', params);
  try {
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return GeocodingResult.fromMapboxJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw GeocodingServiceException('Invalid ${response.statusCode} response from API');
    }
  } on SocketException catch (e) {
    log('mapbox geocoding socket failed: $e');
    throw GeocodingServiceException('No internet connection');
  } catch (e) {
    log('mapbox geocoding failed: $e');
    throw GeocodingServiceException('Internal error');
  }
}

// Note For debugging https://docs.mapbox.com/playground/geocoding/ is helpful
Future<GeocodingResult> mapboxForwardGeocoding(String query, {Position? proximity, int limit = 5}) async {
  final Map<String, String> params = <String, String>{
    'access_token': await MapboxOptions.getAccessToken(),
    'limit': limit.toString(),
  };
  if (proximity != null) {
    params['proximity'] = _mapboxPositionToString(proximity);
  }
  return _mapboxGeocoding(query, params);
}

// Note For debugging https://docs.mapbox.com/playground/geocoding/ is helpful
// Consider improving it: https://nominatim.openstreetmap.org/ui/reverse.html
Future<GeocodingResult> mapboxReverseGeocoding(Position query, {int limit = 1}) async {
  final Map<String, String> params = <String, String>{
    'access_token': await MapboxOptions.getAccessToken(),
    // Not included: country,region,postcode,district,locality,neighborhood,place,poi
    'types': 'address',
    // If multiple types are set the limit must not be set.
    'limit': limit.toString(),
  };
  return _mapboxGeocoding(_mapboxPositionToString(query), params);
}

String _mapboxPositionToString(Position position, {int fractionDigits = 6}) {
  return '${position.lng.toStringAsFixed(fractionDigits)},${position.lat.toStringAsFixed(fractionDigits)}';
}

Future<GeocodingResult> osmReverseGeocoding(Position position, {int zoom = 18}) async {
  final Uri url = Uri.https('nominatim.openstreetmap.org', 'reverse.php', <String, String>{
    'lat': position.lat.toStringAsFixed(6),
    'lon': position.lng.toStringAsFixed(6),
    'zoom': zoom.toString(),
    'format': 'jsonv2'
  });
  try {
    final http.Response response =
        await http.get(url, headers: <String, String>{'User-Agent': 'Android app $androidAppID'});
    if (response.statusCode == 200) {
      return GeocodingResult.fromOsmJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw GeocodingServiceException('Invalid ${response.statusCode} response from API');
    }
  } on SocketException catch (e) {
    log('osm geocoding socket failed: $e');
    throw GeocodingServiceException('No internet connection');
  } catch (e) {
    log('osm geocoding failed: $e');
    throw GeocodingServiceException('Internal error');
  }
}
