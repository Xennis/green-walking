// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static m0(name) => "Entwickelt von ${name}";

  static m1(name) => "${name} Repository";

  static m2(version) => "Version ${version}";

  static m3(appName) => "${appName} Feedback";

  static m4(mail) => "Mail an ${mail} senden";

  static m5(paragraphNumber) => "Angaben gemäß § ${paragraphNumber} TMG";

  static m6(name) => "${name} Karte";

  static m7(name) => "Powered by ${name}";

  static m8(dots) => "Suche${dots}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutLegalese" : m0,
    "aboutPage" : MessageLookupByLibrary.simpleMessage("Über die App"),
    "aboutRepository" : m1,
    "aboutSourceCodeText" : MessageLookupByLibrary.simpleMessage("Um den Quellcode der App zu sehen, besuche bitte das"),
    "aboutVersion" : m2,
    "appSlogan" : MessageLookupByLibrary.simpleMessage("Entdecke deine grüne Stadt!"),
    "appTitle" : MessageLookupByLibrary.simpleMessage("Green Walking"),
    "attributionInfoSemanticLabel" : MessageLookupByLibrary.simpleMessage("Copyright-Informationen anzeigen"),
    "dataPrivacyNavigationLabel" : MessageLookupByLibrary.simpleMessage("Datenschutz"),
    "details" : MessageLookupByLibrary.simpleMessage("Details"),
    "errorNoConnectionToSearchServer" : MessageLookupByLibrary.simpleMessage("Keine Verbindung zum Suchserver"),
    "errorNoPositionFound" : MessageLookupByLibrary.simpleMessage("Keine Position gefunden"),
    "fallbackDescription" : MessageLookupByLibrary.simpleMessage("Die Beschreibung ist nur in der lokalen Sprache verfügbar."),
    "feedbackMailSubject" : m3,
    "feedbackPage" : MessageLookupByLibrary.simpleMessage("Feedback senden"),
    "feedbackPageText" : MessageLookupByLibrary.simpleMessage("Du hast Feedback für die App? Zögere nicht, es uns zuzusenden und damit die App zu verbessern.\n\nDu kannst zum Beispiel Feedback geben zu dem Design und der Bedienbarkeit der App, nicht angezeigten Grünanlagen, wünschenswerten Funktionen, Fehlern oder Funktionen, die dir besonders gut gefallen."),
    "feedbackSendLabel" : MessageLookupByLibrary.simpleMessage("Feedback senden"),
    "feedbackSendMailToLabel" : m4,
    "gdprAgree" : MessageLookupByLibrary.simpleMessage("Einverstanden"),
    "gdprDialogText" : MessageLookupByLibrary.simpleMessage("Für das beste Erlebnis aktiviert die App Tracking. Weitere Infos erhälst du in der"),
    "gdprDisagree" : MessageLookupByLibrary.simpleMessage("Nein danke"),
    "gdprPrivacyPolicy" : MessageLookupByLibrary.simpleMessage("Datenschutzerklärung"),
    "image" : MessageLookupByLibrary.simpleMessage("Foto"),
    "imprint" : MessageLookupByLibrary.simpleMessage("Impressum"),
    "imprintDisclaimerLabel" : MessageLookupByLibrary.simpleMessage("Haftungsausschluss"),
    "imprintDisclaimerText" : MessageLookupByLibrary.simpleMessage("Wir übernehmen keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich."),
    "imprintGdprApplyText" : MessageLookupByLibrary.simpleMessage("Es gilt die"),
    "imprintTmgText" : m5,
    "improveData" : MessageLookupByLibrary.simpleMessage("Verbessere diese Daten"),
    "mapAttributionTitle" : m6,
    "mapSwitchLayerSemanticLabel" : MessageLookupByLibrary.simpleMessage("Kartenansicht wechseln"),
    "maps" : MessageLookupByLibrary.simpleMessage("Maps"),
    "metaDataAttributionTitle" : MessageLookupByLibrary.simpleMessage("Daten"),
    "missingDescription" : MessageLookupByLibrary.simpleMessage("Der Ort hat bisher keine Beschreibung."),
    "nameless" : MessageLookupByLibrary.simpleMessage("Namenlos"),
    "ok" : MessageLookupByLibrary.simpleMessage("Ok"),
    "openInBrowserSemanticLabel" : MessageLookupByLibrary.simpleMessage("Im Browser öffnen"),
    "poweredBy" : m7,
    "searchBoxHintLabel" : m8,
    "searchNoResultsText" : MessageLookupByLibrary.simpleMessage("Keine Ergebnisse gefunden"),
    "searchResults" : MessageLookupByLibrary.simpleMessage("Ergebnisse"),
    "settingsPage" : MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "settingsTrackingDescription" : MessageLookupByLibrary.simpleMessage("Trackingdienst aktivieren"),
    "text" : MessageLookupByLibrary.simpleMessage("Text"),
    "website" : MessageLookupByLibrary.simpleMessage("Webseite")
  };
}
