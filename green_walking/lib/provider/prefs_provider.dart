import 'package:flutter/material.dart';
import 'package:green_walking/services/app_prefs.dart';

class AppPrefsProvider extends ChangeNotifier {
  AppPrefsProvider(bool load) {
    if (load) {
      // Can be disabled for testing reasons.
      _loadFromPrefs();
    }
  }

  ThemeMode? themeMode;
  Locale? locale;

  void setThemeMode(ThemeMode? value) async {
    themeMode = value;
    await AppPrefs.setThemeMode(value);
    notifyListeners();
  }

  void setLanguage(Locale? value) async {
    locale = value;
    await AppPrefs.setLocale(value);
    notifyListeners();
  }

  _loadFromPrefs() async {
    themeMode = await AppPrefs.getThemeMode();
    locale = await AppPrefs.getLocale();
    notifyListeners();
  }
}
