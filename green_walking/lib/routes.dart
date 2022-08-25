import 'package:flutter/widgets.dart';

import 'pages/feedback.dart';
import 'pages/imprint.dart';
import 'pages/map/map.dart';
import 'pages/settings.dart';

class Routes {
  static const String feedback = 'feedback';
  static const String imprint = 'imprint';
  static const String map = 'map';
  static const String privacy = 'privacy';
  static const String settings = 'settings';
}

Map<String, WidgetBuilder> getRoutes(BuildContext context) {
  return <String, WidgetBuilder>{
    Routes.feedback: (_) => FeedbackPage(),
    Routes.imprint: (_) => ImprintPage(),
    Routes.map: (_) => const MapPage(),
    Routes.settings: (_) => SettingsPage(),
  };
}
