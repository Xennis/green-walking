import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';
import '../services/shared_prefs.dart';

void enableAnalyticsOrConsent(BuildContext context) {
  SharedPrefs.getBool(SharedPrefs.analyticsEnabled).then((bool? enabled) {
    if (enabled == true) {
      // Privacy: Only enable analytics if it is set to enabled.
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    } else if (enabled == null) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) => const GdprDialog());
    }
  });
}

class GdprDialog extends StatelessWidget {
  const GdprDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${locale.gdprDialogText} ',
                    ),
                    TextSpan(
                      text: locale.gdprPrivacyPolicy,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(privacyPolicyUrl);
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
        TextButton(
            child: Text(locale.gdprDisagree.toUpperCase()),
            onPressed: () {
              SharedPrefs.setBool(SharedPrefs.analyticsEnabled, false);
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
              Navigator.of(context).pop();
            }),
        TextButton(
            child: Text(locale.gdprAgree.toUpperCase()),
            onPressed: () {
              SharedPrefs.setBool(SharedPrefs.analyticsEnabled, true);
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
