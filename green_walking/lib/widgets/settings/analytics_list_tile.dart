import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/app_prefs.dart';

class AnalyticsListTile extends StatefulWidget {
  const AnalyticsListTile({super.key});

  @override
  State<AnalyticsListTile> createState() => _AnalyticsListTileState();
}

class _AnalyticsListTileState extends State<AnalyticsListTile> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.analytics_outlined),
      title: const Text("Google Analytics"),
      subtitle: Text(
        locale.settingsTrackingDescription,
      ),
      trailing: FutureBuilder<bool?>(
          future: AppPrefs.getBool(AppPrefs.analyticsEnabled),
          initialData: _enabled,
          builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
            return Switch(
                value: snapshot.data ?? false,
                onChanged: (bool? newValue) {
                  if (newValue == null) {
                    return;
                  }
                  AppPrefs.setBool(AppPrefs.analyticsEnabled, newValue);
                  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(newValue);
                  setState(() {
                    _enabled = newValue;
                  });
                });
          }),
      onTap: () => {},
    );
  }
}
