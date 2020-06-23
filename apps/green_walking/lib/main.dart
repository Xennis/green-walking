import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(GreenWalkingApp());
}

class GreenWalkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Walking',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.map,
      routes: () {
        Map<String, WidgetBuilder> routes = Routes.get(context);
        return routes;
      }(),
    );
  }
}
