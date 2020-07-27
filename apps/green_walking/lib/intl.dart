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

  String get title {
    return Intl.message(
      'Green Walking',
      name: 'title',
      desc: 'Title of the application',
      locale: localeName,
    );
  }

  String get slogan {
    return Intl.message(
      'Discover your green city!',
      name: 'slogan',
      desc: 'Slogan of the application',
      locale: localeName,
    );
  }

  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: 'Website label',
      locale: localeName,
    );
  }

  String get maps {
    return Intl.message(
      'Maps',
      name: 'maps',
      desc: 'Maps label',
      locale: localeName,
    );
  }

  String get nameless {
    return Intl.message(
      'Nameless',
      name: 'nameless',
      desc: 'Places without a name',
      locale: localeName,
    );
  }

  String get missingDescription {
    return Intl.message(
      'The park has no description yet.',
      name: 'missingDescription',
      desc: 'Places without a description',
      locale: localeName,
    );
  }

  String get settingsPage {
    return Intl.message(
      'Settings',
      name: 'settingsPage',
      desc: 'Label for settings page',
      locale: localeName,
    );
  }

  String get feedbackPage {
    return Intl.message(
      'Send feedback',
      name: 'feedbackPage',
      desc: 'Label for feedback page',
      locale: localeName,
    );
  }

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
        desc: 'Label for about page',
        locale: localeName,
        examples: const <String, String>{'name': 'Xennis'});
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate(this.overriddenLocale);
  final Locale overriddenLocale;

  @override
  bool isSupported(Locale locale) =>
      <String>['de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
