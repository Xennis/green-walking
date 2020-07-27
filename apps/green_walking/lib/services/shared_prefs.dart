import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong/latlong.dart';
import 'package:dart_geohash/dart_geohash.dart';

class SharedPrefs {
  static const String KEY_LAST_LOCATION = 'last-location';
  static const String ANALYTICS_ENABLED = 'analytics-enabled';
  static const String LANGUAGE = 'language';

  static Future<LatLng> getLatLng(String key) async {
    final String raw = await getString(key);
    if (raw == null) {
      return null;
    }
    try {
      final List<double> res = GeoHasher().decode(raw);
      return LatLng(res[1], res[0]);
    } catch (e) {
      // No last location is not critical. A raised exception on start up is.
      log('failed to load location: ' + e.toString());
      return null;
    }
  }

  static void setLatLng(String key, LatLng val) {
    if (val == null) {
      return;
    }
    try {
      final String raw = GeoHasher().encode(val.longitude, val.latitude);
      setString(key, raw);
    } catch (e) {
      log('failed to store location: ' + e.toString());
    }
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static void setString(String key, String val) {
    SharedPreferences.getInstance()
        .then((SharedPreferences prefs) => prefs.setString(key, val));
  }

  static Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool raw = prefs.getBool(key);
    if (raw == null) {
      return false;
    }
    return raw;
  }

  static void setBool(String key, bool val) {
    if (val == null) {
      return;
    }
    SharedPreferences.getInstance()
        .then((SharedPreferences prefs) => prefs.setBool(key, val));
  }
}
