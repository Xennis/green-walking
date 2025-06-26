import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/prefs_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageListTile extends StatefulWidget {
  const LanguageListTile(this.locale, {super.key});

  final Locale? locale;

  @override
  State<LanguageListTile> createState() => _LanguageListTileState();
}

class _LanguageListTileState extends State<LanguageListTile> {
  late Locale? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.locale;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final AppPrefsProvider prefsProvider = Provider.of<AppPrefsProvider>(context);

    final Map<Locale?, String> languages = {
      null: "(${locale.optionSystem})",
      // No l10n here. Always show the native language names.
      const Locale("de"): "Deutsch",
      const Locale("en"): "English"
    };

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(locale.language),
      trailing: DropdownButton<Locale?>(
          value: _selectedLanguage,
          onChanged: (Locale? newValue) {
            prefsProvider.setLanguage(newValue);
            setState(() {
              _selectedLanguage = newValue;
            });
          },
          items: languages.entries
              .map((e) => DropdownMenuItem<Locale?>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList()),
      onTap: () => {},
    );
  }
}
