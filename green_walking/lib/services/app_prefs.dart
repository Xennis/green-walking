import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:green_walking/services/app_prefs_camera_state.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show CameraState;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class AppPrefs {
  static const String keyLastPosition = 'last-position';
  static const String crashReportingEnabled = 'crash-reporting-enabled';

  static const String _keyThemeMode = 'themeMode';
  static const String _keyLanguage = 'language';

  static Future<CameraState?> getCameraState(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(key);
    if (raw == null) {
      return null;
    }
    try {
      return CameraStatePrefs.fromJson(jsonDecode(raw));
    } catch (e) {
      // No last location is not critical. A raised exception on start up is.
      log('failed to load location: $e');
      return null;
    }
  }

  static Future<bool> setCameraState(String key, CameraState val) async {
    try {
      final String raw = jsonEncode(val.toJson());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, raw);
      return Future.value(true);
    } catch (e) {
      log('failed to store location: $e');
      return Future.value(false);
    }
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBool(String key, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, val);
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
