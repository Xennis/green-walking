import 'dart:convert';
import 'dart:developer';

import 'package:latlong2/latlong.dart' show LatLng;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedPrefs {
  static const String KEY_LAST_LOCATION = 'last-location';
  static const String ANALYTICS_ENABLED = 'analytics-enabled';

  static Future<LatLng?> getLatLng(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(key);
    if (raw == null) {
      return null;
    }
    try {
      final Map<String, dynamic> parsed = jsonDecode(raw) as Map<String, dynamic>;
      return LatLng.fromJson(parsed);
    } catch (e) {
      // No last location is not critical. A raised exception on start up is.
      log('failed to load location: ' + e.toString());
      return null;
    }
  }

  static void setLatLng(String key, LatLng val) {
    try {
      final String raw = val.toJson().toString();
      SharedPreferences.getInstance()
          .then((SharedPreferences prefs) => prefs.setString(key, raw));
    } catch (e) {
      log('failed to store location: ' + e.toString());
    }
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static void setBool(String key, bool val) {
    SharedPreferences.getInstance()
        .then((SharedPreferences prefs) => prefs.setBool(key, val));
  }
}