import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/legal_notice.dart';
import 'package:green_walking/l10n/app_localizations.dart';

void main() {
  testWidgets('LegalNoticePage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: LegalNoticePage(), localizationsDelegates: <LocalizationsDelegate<dynamic>>[AppLocalizations.delegate]));
  });
}
