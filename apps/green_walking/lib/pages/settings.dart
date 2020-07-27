import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:green_walking/intl.dart';
import 'package:green_walking/services/shared_prefs.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _language;
  bool _analyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('Sprache', style: TextStyle(fontSize: 16.0)),
                        Text(
                          'Sprache der App',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    FutureBuilder<String>(
                        future: SharedPrefs.getString(SharedPrefs.LANGUAGE),
                        initialData: _language,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return DropdownButton<String>(
                              value: snapshot.data,
                              items: const <DropdownMenuItem<String>>[
                                //DropdownMenuItem<String>(
                                //    value: null, child: Text('Standard')),
                                DropdownMenuItem<String>(
                                    value: 'de', child: Text('Deutsch')),
                                DropdownMenuItem<String>(
                                    value: 'en', child: Text('English')),
                              ],
                              onChanged: (String newValue) {
                                print("fuubar $newValue");
                                SharedPrefs.setString(
                                    SharedPrefs.LANGUAGE, newValue);
                                setState(() {
                                  AppLocalizations.load(Locale(newValue, ''));
                                  _language = newValue;
                                });
                              });
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('Google Analytics',
                            style: TextStyle(fontSize: 16.0)),
                        Text(
                          'Trackingdienst aktivieren',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    FutureBuilder<bool>(
                        future:
                            SharedPrefs.getBool(SharedPrefs.ANALYTICS_ENABLED),
                        initialData: _analyticsEnabled,
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          return Switch(
                            value: snapshot.data,
                            onChanged: (bool value) {
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
              ],
            )),
      ),
    );
  }
}
