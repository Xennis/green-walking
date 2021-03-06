import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/intl.dart';
import 'package:green_walking/pages/settings.dart';

void main() {
  testWidgets('SettingsPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SettingsPage(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizationsDelegate()
        ]));
  });
}
