// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
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
  String get localeName => 'messages';

  static m0(name) => "Developed by ${name}";

  static m1(name) => "${name} repository";

  static m2(version) => "Version ${version}";

  static m3(appName) => "${appName} Feedback";

  static m4(mail) => "Send mail to ${mail}";

  static m5(paragraphNumber) => "Information in accordance with § ${paragraphNumber} TMG";

  static m6(name) => "${name} map";

  static m7(name) => "Powered by ${name}";

  static m8(dots) => "Search${dots}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutLegalese" : m0,
    "aboutPage" : MessageLookupByLibrary.simpleMessage("About the app"),
    "aboutRepository" : m1,
    "aboutSourceCodeText" : MessageLookupByLibrary.simpleMessage("To see the source code of this app, please visit the"),
    "aboutVersion" : m2,
    "appSlogan" : MessageLookupByLibrary.simpleMessage("Discover your green city!"),
    "appTitle" : MessageLookupByLibrary.simpleMessage("Green Walking"),
    "attributionInfoSemanticLabel" : MessageLookupByLibrary.simpleMessage("Display attribution"),
    "dataPrivacyNavigationLabel" : MessageLookupByLibrary.simpleMessage("Data privacy"),
    "details" : MessageLookupByLibrary.simpleMessage("details"),
    "errorNoConnectionToSearchServer" : MessageLookupByLibrary.simpleMessage("No connection to search server"),
    "errorNoPositionFound" : MessageLookupByLibrary.simpleMessage("No position found"),
    "fallbackDescription" : MessageLookupByLibrary.simpleMessage("The description is only available in the locale language."),
    "feedbackMailSubject" : m3,
    "feedbackPage" : MessageLookupByLibrary.simpleMessage("Send feedback"),
    "feedbackPageText" : MessageLookupByLibrary.simpleMessage("Don\'t hesitate to send your feedback and help to improve the app. Tell us what is good, bad or missing."),
    "feedbackSendLabel" : MessageLookupByLibrary.simpleMessage("Send feedback"),
    "feedbackSendMailToLabel" : m4,
    "gdprAgree" : MessageLookupByLibrary.simpleMessage("Agreed"),
    "gdprDialogText" : MessageLookupByLibrary.simpleMessage("For the best experiance the app enables tracking. Further information can be found in the"),
    "gdprDisagree" : MessageLookupByLibrary.simpleMessage("No thanks"),
    "gdprPrivacyPolicy" : MessageLookupByLibrary.simpleMessage("privacy policy"),
    "image" : MessageLookupByLibrary.simpleMessage("Image"),
    "imprint" : MessageLookupByLibrary.simpleMessage("Imprint"),
    "imprintDisclaimerLabel" : MessageLookupByLibrary.simpleMessage("Disclaimer"),
    "imprintDisclaimerText" : MessageLookupByLibrary.simpleMessage("We decline any liability for the contents of external links, for which only the respective webmasters are responsible."),
    "imprintGdprApplyText" : MessageLookupByLibrary.simpleMessage("The following policy is applied:"),
    "imprintTmgText" : m5,
    "improveData" : MessageLookupByLibrary.simpleMessage("Improve the data"),
    "mapAttributionTitle" : m6,
    "mapSwitchLayerSemanticLabel" : MessageLookupByLibrary.simpleMessage("Switch map layer"),
    "maps" : MessageLookupByLibrary.simpleMessage("Maps"),
    "metaDataAttributionTitle" : MessageLookupByLibrary.simpleMessage("Data"),
    "missingDescription" : MessageLookupByLibrary.simpleMessage("The place has no description yet."),
    "nameless" : MessageLookupByLibrary.simpleMessage("Nameless"),
    "ok" : MessageLookupByLibrary.simpleMessage("ok"),
    "openInBrowserSemanticLabel" : MessageLookupByLibrary.simpleMessage("Open in browser"),
    "poweredBy" : m7,
    "searchBoxHintLabel" : m8,
    "searchNoResultsText" : MessageLookupByLibrary.simpleMessage("No hits found"),
    "searchResults" : MessageLookupByLibrary.simpleMessage("Results"),
    "settingsPage" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTrackingDescription" : MessageLookupByLibrary.simpleMessage("Enable tracking service"),
    "text" : MessageLookupByLibrary.simpleMessage("Text"),
    "website" : MessageLookupByLibrary.simpleMessage("Website")
  };
}
