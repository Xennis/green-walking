import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../services/app_prefs.dart';

void enableCrashReportingOrConsent(BuildContext context) {
  AppPrefs.getBool(AppPrefs.crashReportingEnabled).then((bool? enabled) {
    if (enabled == true) {
      // Privacy: Only enable if it is set to enabled.
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else if (enabled == null) {
      if (!context.mounted) return;
      showDialog<dynamic>(context: context, builder: (BuildContext context) => const UserConsentDialog());
    }
  });
}

class UserConsentDialog extends StatelessWidget {
  const UserConsentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RichText(
              text: TextSpan(style: TextStyle(color: theme.colorScheme.secondary), children: <InlineSpan>[
                TextSpan(
                  text: '${locale.gdprDialogText} ',
                ),
                TextSpan(
                  text: locale.gdprPrivacyPolicy,
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(privacyPolicyUrl);
                    },
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(color: theme.colorScheme.secondary),
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
              AppPrefs.setBool(AppPrefs.crashReportingEnabled, false);
              FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
              Navigator.of(context).pop();
            }),
        TextButton(
            child: Text(locale.gdprAgree.toUpperCase()),
            onPressed: () {
              AppPrefs.setBool(AppPrefs.crashReportingEnabled, true);
              FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
