import 'package:flutter/material.dart';
import 'package:green_walking/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/feedback.dart';

void main() {
  testWidgets('FeedbackPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: FeedbackPage(), localizationsDelegates: <LocalizationsDelegate<dynamic>>[AppLocalizations.delegate]));
  });
}
