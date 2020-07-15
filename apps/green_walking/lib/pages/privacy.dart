import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutz'),
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
                    text: 'Datenschutzerklärung\n\n',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TextSpan(
                    text: 'TODO',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
