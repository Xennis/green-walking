import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
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
                    text: 'Feedback senden\n\n',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TextSpan(
                    text:
                        'Du hast Feedback für die App? Zögere nicht und sende es uns zu, um damit die App zu verbessern.\n\nDu kannst zum Beispiel Feedback geben zu dem Design und der Bedienbarkeit der App, nicht angezeigten Grünanlagen, wünschenswerten Funktionen, Fehlern oder Funktionen, die dir besonders gut gefallen.\n',
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    final Uri mailTo = Uri(
                      scheme: 'mailto',
                      path: 'code@xennis.org',
                      queryParameters: <String, String>{
                        'subject': 'Green Walking Feedback',
                        //'body': 'App Version xx',
                      },
                    );
                    launch(mailTo.toString());
                  },
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: const Text('Mail an code@xennis.org senden'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
