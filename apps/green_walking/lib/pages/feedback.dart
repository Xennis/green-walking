import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intl.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
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
                style: const TextStyle(color: Colors.black),
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
                  onPressed: () {
                    final Uri mailTo = Uri(
                      scheme: 'mailto',
                      path: 'code@xennis.org',
                      queryParameters: <String, String>{
                        'subject': locale.feedbackMailSubject(locale.appTitle),
                        //'body': 'App Version xx',
                      },
                    );
                    launch(mailTo.toString());
                  },
                  child:
                      Text(locale.feedbackSendMailToLabel('code@xennis.org')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
