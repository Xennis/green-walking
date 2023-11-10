import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../services/app_prefs.dart';

void enableAnalyticsOrConsent(BuildContext context) {
  AppPrefs.getBool(AppPrefs.analyticsEnabled).then((bool? enabled) {
    if (enabled == true) {
      // Privacy: Only enable analytics if it is set to enabled.
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    } else if (enabled == null) {
      showDialog<dynamic>(context: context, builder: (BuildContext context) => const GdprDialog());
    }
  });
}

class GdprDialog extends StatelessWidget {
  const GdprDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RichText(
              text: TextSpan(style: TextStyle(color: theme.hintColor), children: <InlineSpan>[
                TextSpan(
                  text: '${locale.gdprDialogText} ',
                ),
                TextSpan(
                  text: locale.gdprPrivacyPolicy,
                  style: TextStyle(color: theme.primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(privacyPolicyUrl);
                    },
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(color: theme.hintColor),
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
              AppPrefs.setBool(AppPrefs.analyticsEnabled, false);
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
              Navigator.of(context).pop();
            }),
        TextButton(
            child: Text(locale.gdprAgree.toUpperCase()),
            onPressed: () {
              AppPrefs.setBool(AppPrefs.analyticsEnabled, true);
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
