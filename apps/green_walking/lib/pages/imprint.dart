import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class ImprintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressum'),
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
                    text: 'Impressum\n\n',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TextSpan(
                    text: 'Angaben gemäß § 5 TMG:\n\n',
                  ),
                  const TextSpan(
                      text: 'Fabian Rosenthal / Green Walking\n',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                      text:
                          'c/o skriptspektor e. U.\nRobert-Preußler-Straße 13 / TOP 1\n5020 Salzburg\nAT – Österreich\ncode [at] xennis.org\n\n'),
                  const TextSpan(
                    text: 'Haftungshinweis:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        ' Wir übernehmen keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.\n\n',
                  ),
                  const TextSpan(text: 'Es gilt die '),
                  TextSpan(
                    text: 'Datenschutzerklärung',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => Navigator.of(context).pushNamed(Routes.privacy),
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
