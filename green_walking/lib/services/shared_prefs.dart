import 'dart:convert';
import 'dart:developer';

import 'package:mapbox_gl/mapbox_gl.dart' show CameraPosition, LatLng;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedPrefs {
  static const String keyLastPosition = 'last-position';
  static const String analyticsEnabled = 'analytics-enabled';

  static Future<CameraPosition?> getCameraPosition(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(key);
    if (raw == null) {
      return null;
    }
    try {
      final Map<String, dynamic> parsed =
          jsonDecode(raw) as Map<String, dynamic>;
      final List<dynamic> parsedTarget = parsed['target'] as List<dynamic>;

      return CameraPosition(
        bearing: parsed['bearing'],
        target: LatLng(parsedTarget[0] as double, parsedTarget[1] as double),
        tilt: parsed['tilt'],
        zoom: parsed['zoom'],
      );
    } catch (e) {
      // No last location is not critical. A raised exception on start up is.
      log('failed to load location: $e');
      return null;
    }
  }

  static void setCameraPosition(String key, CameraPosition val) {
    try {
      final String raw = jsonEncode(val.toMap());
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
