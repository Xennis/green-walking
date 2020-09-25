import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get aboutPage {
    return Intl.message(
      'About the app',
      name: 'aboutPage',
      desc: 'Label for about page',
      locale: localeName,
    );
  }

  String aboutVersion(String version) {
    return Intl.message('Version $version',
        name: 'aboutVersion',
        args: <Object>[version],
        desc: 'Version on the about page',
        locale: localeName,
        examples: const <String, String>{'version': '1.0.0'});
  }

  String aboutLegalese(String name) {
    return Intl.message('Developed by $name',
        name: 'aboutLegalese',
        args: <Object>[name],
        desc: 'Developer attribution',
        locale: localeName,
        examples: const <String, String>{'name': 'Xennis'});
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
