import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../core.dart';
import '../routes.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
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
          _RateAppListTile(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(locale.settingsPage),
            onTap: () => Navigator.of(context).pushNamed(Routes.settings),
          ),
          const Divider(),
          AboutListTile(
            icon: const Icon(Icons.explore),
            applicationIcon: Image.asset(
              'assets/app-icon.png',
              width: 65,
              height: 65,
            ),
            applicationName: locale.appTitle,
            applicationVersion: locale.aboutVersion(appVersion),
            applicationLegalese: locale.aboutLegalese(appAuthor),
            child: Text(locale.aboutPage),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(locale.dataPrivacyNavigationLabel),
            onTap: () => launchUrl(privacyPolicyUrl),
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

class _RateAppListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      final AppLocalizations l10n = AppLocalizations.of(context)!;
      return ListTile(
          leading: const Icon(Icons.star),
          title: Text(l10n.rateApp),
          onTap: () => launchUrl(
              Uri.https('play.google.com', '/store/apps/details',
                  {'id': androidAppID}),
              mode: LaunchMode.externalApplication));
    }
    return Container();
  }
}
