import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/shared_prefs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _analyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.settingsPage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Google Analytics',
                          style: TextStyle(fontSize: 16.0)),
                      Text(
                        locale.settingsTrackingDescription,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  FutureBuilder<bool?>(
                      future: SharedPrefs.getBool(SharedPrefs.analyticsEnabled),
                      initialData: _analyticsEnabled,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool?> snapshot) {
                        return Switch(
                          value: snapshot.data ?? false,
                          onChanged: (bool? value) {
                            if (value == null) {
                              return;
                            }
                            SharedPrefs.setBool(
                                SharedPrefs.analyticsEnabled, value);
                            FirebaseAnalytics.instance
                                .setAnalyticsCollectionEnabled(value);
                            setState(() {
                              _analyticsEnabled = value;
                            });
                          },
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
