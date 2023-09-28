import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/search.dart';

void main() {
  testWidgets('SearchPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: SearchPage(
          accessToken: 'some-token',
        ),
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[AppLocalizations.delegate]));
  });
}
