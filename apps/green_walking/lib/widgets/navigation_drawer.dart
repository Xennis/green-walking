import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';
import '../intl.dart';
import '../routes.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
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
                  locale.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ]),
              Row(
                children: <Widget>[
                  Text(locale.appSlogan,
                      style: const TextStyle(
                        color: Colors.white70,
                      )),
                ],
              )
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text(locale.feedbackPage),
            onTap: () => Navigator.of(context).pushNamed(Routes.feedback),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(locale.settingsPage),
            onTap: () => Navigator.of(context).pushNamed(Routes.settings),
          ),
          const Divider(),
          AboutListTile(
            child: Text(locale.aboutPage),
            icon: const Icon(Icons.explore),
            applicationIcon: Image.asset(
              'assets/app-icon.png',
              width: 65,
              height: 65,
            ),
            applicationName: locale.appTitle,
            applicationVersion: locale.aboutVersion('1.5.0'),
            applicationLegalese: locale.aboutLegalese('Xennis'),
            aboutBoxChildren: <Widget>[
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      style: textStyle,
                      text: '${locale.aboutSourceCodeText} ',
                    ),
                    TextSpan(
                      text: locale.aboutRepository('GitHub'),
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
            title: Text(locale.dataPrivacyNavigationLabel),
            onTap: () => launch(privacyPolicyUrl),
            trailing: Icon(
              Icons.open_in_new,
              semanticLabel: locale.openInBrowserSemanticLabel,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(locale.imprint),
            onTap: () => Navigator.of(context).pushNamed(Routes.imprint),
          ),
        ],
      ),
    );
  }
}
