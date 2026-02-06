import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/l10n/app_localizations.dart';
import 'package:green_walking/pages/search.dart';

void main() {
  testWidgets('SearchPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: SearchPage(), localizationsDelegates: <LocalizationsDelegate<dynamic>>[AppLocalizations.delegate]));
  });
}
