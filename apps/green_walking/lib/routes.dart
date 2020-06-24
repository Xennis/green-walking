import 'package:flutter/widgets.dart';
import 'package:green_walking/pages/detail.dart';
import 'pages/map.dart';

class Routes {
  static const String detail = 'detail';
  static const String map = 'map';

  static Map<String, WidgetBuilder> get(BuildContext context) {
    return {
      detail: (context) => DetailPage(),
      map: (context) => MapPage(),
    };
  }
}
