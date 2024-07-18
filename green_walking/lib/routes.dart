import 'package:flutter/widgets.dart';

import 'pages/feedback.dart';
import 'pages/legal_notice.dart';
import 'pages/map.dart';
import 'pages/offline_maps.dart';
import 'pages/settings.dart';

class Routes {
  static const String feedback = 'feedback';
  static const String legalNotice = 'legal-notice';
  static const String map = 'map';
  static const String offlineMaps = 'offline-maps';
  static const String privacy = 'privacy';
  static const String settings = 'settings';
}

Map<String, WidgetBuilder> getRoutes(BuildContext context) {
  return <String, WidgetBuilder>{
    Routes.feedback: (_) => const FeedbackPage(),
    Routes.legalNotice: (_) => const LegalNoticePage(),
    Routes.map: (_) => const MapPage(),
    Routes.offlineMaps: (_) => const OfflineMapsPage(),
    Routes.settings: (_) => const SettingsPage(),
  };
}
