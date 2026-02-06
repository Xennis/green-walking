import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../provider/prefs_provider.dart';

class ThemeListTile extends StatefulWidget {
  const ThemeListTile(this.mode, {super.key});

  final ThemeMode? mode;

  @override
  State<ThemeListTile> createState() => _ThemeListTileState();
}

class _ThemeListTileState extends State<ThemeListTile> {
  late ThemeMode? _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

    final Map<ThemeMode?, String> languages = {
      null: "(${locale.optionSystem})",
      ThemeMode.dark: locale.optionDarkTheme,
      ThemeMode.light: locale.optionLightTheme,
    };

    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: Text(locale.optionTheme),
      trailing: DropdownButton<ThemeMode?>(
          value: _mode,
          onChanged: (ThemeMode? newValue) {
            prefsProvider.setThemeMode(newValue);
            setState(() {
              _mode = newValue;
            });
          },
          items: languages.entries
              .map((e) => DropdownMenuItem<ThemeMode?>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList()),
      onTap: () => {},
    );
  }
}
