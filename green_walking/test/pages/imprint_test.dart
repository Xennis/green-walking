import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/imprint.dart';

void main() {
  testWidgets('ImprintPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ImprintPage(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate
        ]));
  });
}
