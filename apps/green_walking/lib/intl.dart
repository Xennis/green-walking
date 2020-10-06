import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:green_walking/types/language.dart';
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

  String get appTitle {
    return Intl.message(
      'Green Walking',
      name: 'appTitle',
      desc: 'Title of the application',
      locale: localeName,
    );
  }

  String get appSlogan {
    return Intl.message(
      'Discover your green city!',
      name: 'appSlogan',
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
      'The place has no description yet.',
      name: 'missingDescription',
      desc: 'Hint for a places without a description',
      locale: localeName,
    );
  }

  String get fallbackDescription {
    return Intl.message(
      'The description is only available in the locale language.',
      name: 'fallbackDescription',
      desc:
          'Hint if a place description is not available in the users language but in the language of the country the place is located in.',
      locale: localeName,
    );
  }

  String get settingsPage {
    return Intl.message(
      'Settings',
      name: 'settingsPage',
      desc: 'Navigation label and title for settings page',
      locale: localeName,
    );
  }

  String get settingsTrackingDescription {
    return Intl.message(
      'Enable tracking service',
      name: 'settingsTrackingDescription',
      desc: 'Description for enable/disable tracking setting',
      locale: localeName,
    );
  }

  String get feedbackPage {
    return Intl.message(
      'Submit feedback',
      name: 'feedbackPage',
      desc: 'Navigation label and title for feedback page',
      locale: localeName,
    );
  }

  String get feedbackSendLabel {
    return Intl.message(
      'Send feedback',
      name: 'feedbackSendLabel',
      desc: 'Label for sending feedback',
      locale: localeName,
    );
  }

  String get feedbackPageText {
    return Intl.message(
      'You have feedback for the app? Do not hesitate to send it to us to help us improving the app. You can give us feedback on the design and usability of the app, green areas that are not displayed, desirable features, bugs or features that you particularly like.',
      name: 'feedbackPageText',
      desc: 'Text for the feedback page',
      locale: localeName,
    );
  }

  String feedbackSendMailToLabel(String mail) {
    return Intl.message('Send mail to $mail',
        name: 'feedbackSendMailToLabel',
        args: <Object>[mail],
        desc: 'Send feedback mail button label',
        locale: localeName,
        examples: const <String, String>{'mail': 'contact@example.org'});
  }

  String feedbackMailSubject(String appName) {
    return Intl.message('$appName Feedback',
        name: 'feedbackMailSubject',
        args: <Object>[appName],
        desc: 'Feedback mail subject',
        locale: localeName,
        examples: const <String, String>{'appName': 'Green Walking'});
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
        examples: const <String, String>{'version': '1.4.0'});
  }

  String aboutLegalese(String name) {
    return Intl.message('Developed by $name',
        name: 'aboutLegalese',
        args: <Object>[name],
        desc: 'Developer attribution',
        locale: localeName,
        examples: const <String, String>{'name': 'Xennis'});
  }

  String get aboutSourceCodeText {
    return Intl.message(
      'To see the source code of this app, please visit the',
      name: 'aboutSourceCodeText',
      desc: 'Text for mentioning the source code',
      locale: localeName,
    );
  }

  String aboutRepository(String name) {
    return Intl.message('$name repository',
        name: 'aboutRepository',
        args: <Object>[name],
        desc: 'Link for code repository',
        locale: localeName,
        examples: const <String, String>{'name': 'GitHub'});
  }

  String get dataPrivacyNavigationLabel {
    return Intl.message(
      'Data privacy',
      name: 'dataPrivacyNavigationLabel',
      desc: 'Label for data privacy link',
      locale: localeName,
    );
  }

  String get imprint {
    return Intl.message(
      'Legal notice',
      name: 'imprint',
      desc: 'Legal notice. The required "Impressum" due to German law.',
      locale: localeName,
    );
  }

  String imprintTmgText(String paragraphNumber) {
    return Intl.message('Information in accordance with § $paragraphNumber TMG',
        name: 'imprintTmgText',
        args: <Object>[paragraphNumber],
        desc: 'Disclaimer headline on the imprint page',
        locale: localeName,
        examples: const <String, String>{'paragraphNumber': '5'});
  }

  String get imprintDisclaimerLabel {
    return Intl.message(
      'Disclaimer',
      name: 'imprintDisclaimerLabel',
      desc: 'Disclaimer headline on the imprint page',
      locale: localeName,
    );
  }

  String get imprintDisclaimerText {
    return Intl.message(
      'We decline any liability for the contents of external links, for which only the respective webmasters are responsible.',
      name: 'imprintDisclaimerText',
      desc: 'Disclaimer text on the imprint page',
      locale: localeName,
    );
  }

  String get imprintGdprApplyText {
    return Intl.message(
      'The following policy is applied:',
      name: 'imprintGdprApplyText',
      desc: 'Imprint GDPR text',
      locale: localeName,
    );
  }

  String get openInBrowserSemanticLabel {
    return Intl.message(
      'Open in browser',
      name: 'openInBrowserSemanticLabel',
      desc: 'Semantic label for icon to open link in browser',
      locale: localeName,
    );
  }

  String get gdprDialogText {
    return Intl.message(
      'For the best experience the app enables tracking. Further information can be found in the',
      name: 'gdprDialogText',
      desc: 'Text for privacy policy link',
      locale: localeName,
    );
  }

  String get gdprPrivacyPolicy {
    return Intl.message(
      'privacy policy',
      name: 'gdprPrivacyPolicy',
      desc: 'Privacy policy link text',
      locale: localeName,
    );
  }

  String get gdprAgree {
    return Intl.message(
      'I agree',
      name: 'gdprAgree',
      desc: 'GDRP agree button label',
      locale: localeName,
    );
  }

  String get gdprDisagree {
    return Intl.message(
      'No thanks',
      name: 'gdprDisagree',
      desc: 'GDRP disagree button label',
      locale: localeName,
    );
  }

  String get improveData {
    return Intl.message(
      'Improve the data',
      name: 'improveData',
      desc: 'Link text for improving the data',
      locale: localeName,
    );
  }

  String get attributionInfoSemanticLabel {
    return Intl.message(
      'Show copyright information',
      name: 'attributionInfoSemanticLabel',
      desc: 'Semantic label for opening attributions (e.g. map, text, image)',
      locale: localeName,
    );
  }

  String mapAttributionTitle(String name) {
    return Intl.message('$name map',
        name: 'mapAttributionTitle',
        args: <Object>[name],
        desc: 'Title for the map attribution',
        locale: localeName,
        examples: const <String, String>{'name': 'Mapbox'});
  }

  String get metaDataAttributionTitle {
    return Intl.message(
      'Data',
      name: 'metaDataAttributionTitle',
      desc: 'Title for the meta data (e.g. Wikidata) attribution',
      locale: localeName,
    );
  }

  String poweredBy(String name) {
    return Intl.message('Powered by $name',
        name: 'poweredBy',
        args: <Object>[name],
        desc: 'Powered by text',
        locale: localeName,
        examples: const <String, String>{'name': 'Wikidata'});
  }

  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: 'Label for okay',
      locale: localeName,
    );
  }

  String get details {
    return Intl.message(
      'details',
      name: 'details',
      desc: 'Label for details',
      locale: localeName,
    );
  }

  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: 'Noun for an image / photo',
      locale: localeName,
    );
  }

  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: 'Noun for a text',
      locale: localeName,
    );
  }

  String get errorNoPositionFound {
    return Intl.message(
      'No position found',
      name: 'errorNoPositionFound',
      desc:
          'Error message displayed to user if no (GPS) location could be found',
      locale: localeName,
    );
  }

  String get errorNoConnectionToSearchServer {
    return Intl.message(
      'No connection to the search server',
      name: 'errorNoConnectionToSearchServer',
      desc:
          'Error message displayed to user if no geocoding search results can be received from search server',
      locale: localeName,
    );
  }

  String searchBoxHintLabel(String dots) {
    return Intl.message('Search$dots',
        name: 'searchBoxHintLabel',
        args: <Object>[dots],
        desc: 'Hint text for the search box on the map page',
        locale: localeName,
        examples: const <String, String>{'dots': '...'});
  }

  String get searchResults {
    return Intl.message(
      'Results',
      name: 'searchResults',
      desc: 'Search results',
      locale: localeName,
    );
  }

  String get searchNoResultsText {
    return Intl.message(
      'No results found',
      name: 'searchNoResultsText',
      desc: 'Message shown if no search results were found',
      locale: localeName,
    );
  }

  String get mapSwitchLayerSemanticLabel {
    return Intl.message(
      'Switch map layer',
      name: 'mapSwitchLayerSemanticLabel',
      desc:
          'Semantic label for switching the map layer (e.g. to satellite view)',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>[
        Language.de.code,
        Language.en.code
      ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
