import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:green_walking/services/shared_prefs.dart';

import '../intl.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _analyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
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
                      future:
                          SharedPrefs.getBool(SharedPrefs.ANALYTICS_ENABLED),
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
                                SharedPrefs.ANALYTICS_ENABLED, value);
                            FirebaseAnalytics()
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
