import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show CameraState;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class AppPrefs {
  static const String keyLastPosition = 'last-position';
  static const String analyticsEnabled = 'analytics-enabled';

  static const String _keyThemeMode = 'themeMode';
  static const String _keyLanguage = 'language';

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
      SharedPreferences.getInstance().then((SharedPreferences prefs) => prefs.setString(key, raw));
    } catch (e) {
      log('failed to store location: $e');
    }
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static void setBool(String key, bool val) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) => prefs.setBool(key, val));
  }

  static Future<ThemeMode?> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? raw = prefs.getInt(_keyThemeMode);
    if (raw == null) {
      return null;
    }
    return ThemeMode.values[raw];
  }

  static Future<bool> setThemeMode(ThemeMode? mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode == null) {
      return prefs.remove(_keyThemeMode);
    }
    return prefs.setInt(_keyThemeMode, mode.index);
  }

  static Future<Locale?> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_keyLanguage);
    if (raw == null) {
      return null;
    }
    return Locale(raw);
  }

  static Future<bool> setLocale(Locale? locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      return prefs.remove(_keyLanguage);
    }
    return prefs.setString(_keyLanguage, locale.languageCode);
  }
}
