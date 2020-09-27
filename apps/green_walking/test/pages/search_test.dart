import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/intl.dart';
import 'package:green_walking/pages/search.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';

void main() {
  testWidgets('SearchPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SearchPage(
            result:
                Future<MapboxGeocodingResult>.value(MapboxGeocodingResult())),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizationsDelegate()
        ]));
  });
}
