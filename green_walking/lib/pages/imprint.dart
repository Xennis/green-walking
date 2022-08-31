import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
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
                style: const TextStyle(color: Colors.black),
                children: <InlineSpan>[
                  TextSpan(
                    text: '${locale.imprintTmgText('5')}:\n\n',
                  ),
                  const TextSpan(
                      text:
                          'Fabian Rosenthal\nSchäferkampsallee 61\n20357\nHamburg\nGermany\ncode [at] xennis.org\n\n'),
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
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(privacyPolicyUrl),
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
