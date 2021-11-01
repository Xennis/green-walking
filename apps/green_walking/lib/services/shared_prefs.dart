import 'dart:developer';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:mapbox_gl/mapbox_gl.dart' show LatLng;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedPrefs {
  static const String KEY_LAST_LOCATION = 'last-location';
  static const String ANALYTICS_ENABLED = 'analytics-enabled';

  static Future<LatLng> getLatLng(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString(key);
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
      SharedPreferences.getInstance()
          .then((SharedPreferences prefs) => prefs.setString(key, raw));
    } catch (e) {
      log('failed to store location: ' + e.toString());
    }
  }

  static Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static void setBool(String key, bool val) {
    if (val == null) {
      return;
    }
    SharedPreferences.getInstance()
        .then((SharedPreferences prefs) => prefs.setBool(key, val));
  }
}
