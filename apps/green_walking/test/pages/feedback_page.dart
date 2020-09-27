import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/intl.dart';
import 'package:green_walking/pages/feedback.dart';

void main() {
  testWidgets('FeedbackPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: FeedbackPage(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizationsDelegate()
        ]));
  });
}
