import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/l10n/app_localizations.dart';
import 'package:green_walking/pages/settings.dart';
import 'package:green_walking/provider/prefs_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SettingsPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
        providers: [ListenableProvider<AppPrefsProvider>(create: (context) => AppPrefsProvider(false))],
        child: Builder(
            builder: (_) => const MaterialApp(
                home: SettingsPage(),
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[AppLocalizations.delegate]))));
  });
}
