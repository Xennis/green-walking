import 'package:flutter/widgets.dart';
import 'package:green_walking/pages/feedback.dart';
import 'package:green_walking/pages/imprint.dart';
import 'package:green_walking/pages/settings.dart';
import 'pages/map.dart';

class Routes {
  static const String feedback = 'feedback';
  static const String imprint = 'imprint';
  static const String map = 'map';
  static const String privacy = 'privacy';
  static const String settings = 'settings';

  static Map<String, WidgetBuilder> get(BuildContext context) {
    return <String, WidgetBuilder>{
      feedback: (_) => FeedbackPage(),
      imprint: (_) => ImprintPage(),
      map: (_) => const MapPage(),
      settings: (_) => SettingsPage(),
    };
  }
}
