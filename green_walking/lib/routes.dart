import 'package:flutter/widgets.dart';
import 'package:green_walking/pages/feedback.dart';
import 'package:green_walking/pages/imprint.dart';
import 'package:green_walking/pages/settings.dart';
import 'pages/map/map.dart';

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
