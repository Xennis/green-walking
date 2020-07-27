import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_walking/routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intl.dart';

class NavigationDrawer extends StatelessWidget {
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
              Row(children: <Widget>[
                Text(
                  AppLocalizations.of(context).title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ]),
              Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context).slogan,
                      style: const TextStyle(
                        color: Colors.white70,
                      )),
                ],
              )
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text(AppLocalizations.of(context).feedbackPage),
            onTap: () => Navigator.of(context).pushNamed(Routes.feedback),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settingsPage),
            onTap: () => Navigator.of(context).pushNamed(Routes.settings),
          ),
          const Divider(),
          AboutListTile(
            child: Text(AppLocalizations.of(context).aboutPage),
            icon: const Icon(Icons.explore),
            applicationIcon: Image.asset(
              'assets/app-icon.png',
              width: 65,
              height: 65,
            ),
            applicationName: AppLocalizations.of(context).title,
            applicationVersion:
                AppLocalizations.of(context).aboutVersion('1.4.0'),
            applicationLegalese:
                AppLocalizations.of(context).aboutLegalese('Xennis'),
            aboutBoxChildren: <Widget>[
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        style: textStyle,
                        // To see the source code of this app, please visit the
                        text:
                            'Um den Quellcode der App zu sehen, besuche bitte das '),
                    TextSpan(
                      text: 'GitHub Repository',
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
            leading: const Icon(Icons.lock),
            title: const Text('Datenschutz'),
            onTap: () => launch(
                'https://raw.githubusercontent.com/Xennis/green-walking/master/web/privacy/privacy-de.md'),
            trailing: const Icon(Icons.open_in_new),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Impressum'),
            onTap: () => Navigator.of(context).pushNamed(Routes.imprint),
          ),
        ],
      ),
    );
  }
}
