import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';

void enableAnalyticsOrConsent(BuildContext context) {
  SharedPrefs.getBool(SharedPrefs.ANALYTICS_ENABLED).then((bool enabled) {
    if (enabled) {
      // Privacy: Only enable analytics if it is set to enabled.
      FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
    } else {
      showDialog<dynamic>(
          context: context, builder: (BuildContext context) => GdprDialog());
    }
  });
}

class GdprDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: <InlineSpan>[
                    const TextSpan(
                      text:
                          'Für das beste Erlebnis aktiviert die App Tracking. Weiter Infos erhälst du in der ',
                    ),
                    TextSpan(
                      text: 'Datenschutzerklärung',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                              'https://raw.githubusercontent.com/Xennis/green-walking/master/web/privacy/privacy-de.md');
                        },
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text('NEIN DANKE'),
            onPressed: () {
              SharedPrefs.setBool(SharedPrefs.ANALYTICS_ENABLED, false);
              FirebaseAnalytics().setAnalyticsCollectionEnabled(false);
              Navigator.of(context).pop();
            }),
        FlatButton(
            child: const Text('EINVERSTANDEN'),
            onPressed: () {
              SharedPrefs.setBool(SharedPrefs.ANALYTICS_ENABLED, true);
              FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}