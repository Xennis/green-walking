import 'dart:convert';
import 'dart:developer' show log;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show CameraState;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedPrefs {
  static const String keyLastPosition = 'last-position';
  static const String analyticsEnabled = 'analytics-enabled';

  static Future<CameraState?> getCameraState(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(key);
    if (raw == null) {
      return null;
    }
    try {
      return CameraState.decode(jsonDecode(raw));
    } catch (e) {
      // No last location is not critical. A raised exception on start up is.
      log('failed to load location: $e');
      return null;
    }
  }

  static void setCameraState(String key, CameraState val) {
    try {
      final String raw = jsonEncode(val.encode());
      SharedPreferences.getInstance()
          .then((SharedPreferences prefs) => prefs.setString(key, raw));
    } catch (e) {
      log('failed to store location: $e');
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
