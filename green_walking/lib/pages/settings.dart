import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/prefs_provider.dart';
import '../widgets/settings/analytics_list_tile.dart';
import '../widgets/settings/language_list_tile.dart';
import '../widgets/settings/theme_list_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(locale.settingsPage),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(children: [
                  ThemeListTile(prefsProvider.themeMode),
                  LanguageListTile(prefsProvider.locale),
                  const Divider(),
                  const AnalyticsListTile()
                ]))));
  }
}
