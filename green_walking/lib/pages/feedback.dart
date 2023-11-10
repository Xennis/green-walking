import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.feedbackPage),
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
                    text: '${locale.feedbackPageText}\n',
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _onPressed(locale),
                  child: Text(locale.feedbackSendMailToLabel(supportMail)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(AppLocalizations locale) {
    final Uri mailTo = Uri(
      scheme: 'mailto',
      path: supportMail,
      queryParameters: <String, String>{
        'subject': locale.feedbackMailSubject(locale.appTitle),
        //'body': 'App Version xx',
      },
    );
    launchUrl(mailTo);
  }
}
