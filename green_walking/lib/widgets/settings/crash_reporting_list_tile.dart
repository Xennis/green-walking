import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/app_prefs.dart';

class CrashReportingListTile extends StatefulWidget {
  const CrashReportingListTile({super.key});

  @override
  State<CrashReportingListTile> createState() => _CrashReportingListTileState();
}

class _CrashReportingListTileState extends State<CrashReportingListTile> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.analytics_outlined),
      title: Text(locale.settingsCrashReportingTitle),
      subtitle: Text(
        locale.settingsCrashReportingDescription,
      ),
      trailing: FutureBuilder<bool?>(
          future: AppPrefs.getBool(AppPrefs.crashReportingEnabled),
          initialData: _enabled,
          builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
            return Switch(
                value: snapshot.data ?? false,
                onChanged: (bool? newValue) async {
                  if (newValue == null) {
                    return;
                  }
                  await AppPrefs.setBool(AppPrefs.crashReportingEnabled, newValue);
                  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(newValue);
                  setState(() {
                    _enabled = newValue;
                  });
                });
          }),
    );
  }
}
