import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class LegalNoticePage extends StatelessWidget {
  const LegalNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.imprint),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(color: theme.unselectedWidgetColor),
                children: <InlineSpan>[
                  TextSpan(
                    text: '${locale.imprintTmgText('5')}:\n\n',
                  ),
                  const TextSpan(
                      text: 'Fabian Rosenthal\nMethfesselstraße 96\n20255\nHamburg\nGermany\ncode [at] xennis.org\n\n'),
                  TextSpan(
                    text: '${locale.imprintDisclaimerLabel}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' ${locale.imprintDisclaimerText}\n\n',
                  ),
                  TextSpan(text: '${locale.imprintGdprApplyText} '),
                  TextSpan(
                    text: locale.gdprPrivacyPolicy,
                    style: TextStyle(color: theme.primaryColor),
                    recognizer: TapGestureRecognizer()..onTap = () => launchUrl(privacyPolicyUrl),
                  ),
                  const TextSpan(text: '.')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
