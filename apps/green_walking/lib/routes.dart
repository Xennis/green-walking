import 'package:flutter/widgets.dart';
import 'pages/map.dart';

class Routes {
  static const String map = 'map';

  static Map<String, WidgetBuilder> get(BuildContext context) {
    return {
      map: (context) => MapPage(),
    };
  }
}