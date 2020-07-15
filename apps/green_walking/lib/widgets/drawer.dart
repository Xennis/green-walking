import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_walking/pages/imprint.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            child: Column(children: <Widget>[
              Row(children: const <Widget>[
                Text(
                  'Green Walking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ]),
              Row(
                children: const <Widget>[
                  Text('Entdecke deine grüne Stadt!',
                      style: TextStyle(
                        color: Colors.white70,
                      )),
                ],
              )
            ]),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen'),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Hilfe'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback senden'),
          ),
          AboutListTile(
            child: const Text('Über die App'),
            icon: const Icon(Icons.explore),
            applicationIcon: Image.asset(
              'assets/app-icon.png',
              width: 65,
              height: 65,
            ),
            applicationName: 'Green Walking',
            applicationVersion: 'Version 0.1.0',
            applicationLegalese: 'Developed by Xennis',
            aboutBoxChildren: <Widget>[
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        style: textStyle,
                        text:
                            'To see the source code of this app, please visit the '),
                    TextSpan(
                      text: 'GitHub repository',
                      style: TextStyle(color: Theme.of(context).accentColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://github.com/Xennis/green-walking');
                        },
                    ),
                    TextSpan(style: textStyle, text: '.'),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Impressum'),
            onTap: () {
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => ImprintPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
