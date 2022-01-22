// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, always_declare_return_types

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

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
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "aboutLegalese" : m0,
    "aboutPage" : MessageLookupByLibrary.simpleMessage("About the app"),
    "aboutRepository" : m1,
    "aboutSourceCodeText" : MessageLookupByLibrary.simpleMessage("To see the source code of this app, please visit the"),
    "aboutVersion" : m2,
    "appSlogan" : MessageLookupByLibrary.simpleMessage("Discover your green city!"),
    "appTitle" : MessageLookupByLibrary.simpleMessage("Green Walking"),
    "attributionInfoSemanticLabel" : MessageLookupByLibrary.simpleMessage("Show copyright information"),
    "dataPrivacyNavigationLabel" : MessageLookupByLibrary.simpleMessage("Data privacy"),
    "details" : MessageLookupByLibrary.simpleMessage("details"),
    "errorNoConnectionToSearchServer" : MessageLookupByLibrary.simpleMessage("No connection to the search server"),
    "errorNoPositionFound" : MessageLookupByLibrary.simpleMessage("No position found"),
    "fallbackDescription" : MessageLookupByLibrary.simpleMessage("The description is only available in the locale language."),
    "feedbackMailSubject" : m3,
    "feedbackPage" : MessageLookupByLibrary.simpleMessage("Submit feedback"),
    "feedbackPageText" : MessageLookupByLibrary.simpleMessage("You have feedback for the app? Do not hesitate to send it to us to help us improving the app. You can give us feedback on the design and usability of the app, green areas that are not displayed, desirable features, bugs or features that you particularly like."),
    "feedbackSendLabel" : MessageLookupByLibrary.simpleMessage("Send feedback"),
    "feedbackSendMailToLabel" : m4,
    "gdprAgree" : MessageLookupByLibrary.simpleMessage("I agree"),
    "gdprDialogText" : MessageLookupByLibrary.simpleMessage("For the best experience the app enables tracking. Further information can be found in the"),
    "gdprDisagree" : MessageLookupByLibrary.simpleMessage("No thanks"),
    "gdprPrivacyPolicy" : MessageLookupByLibrary.simpleMessage("privacy policy"),
    "image" : MessageLookupByLibrary.simpleMessage("Image"),
    "imprint" : MessageLookupByLibrary.simpleMessage("Legal notice"),
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
    "searchNoResultsText" : MessageLookupByLibrary.simpleMessage("No results found"),
    "searchResults" : MessageLookupByLibrary.simpleMessage("Results"),
    "settingsPage" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTrackingDescription" : MessageLookupByLibrary.simpleMessage("Enable tracking service"),
    "text" : MessageLookupByLibrary.simpleMessage("Text"),
    "website" : MessageLookupByLibrary.simpleMessage("Website")
  };
}
