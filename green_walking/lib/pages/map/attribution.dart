import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Attribution extends StatelessWidget {
  const Attribution({
    Key? key,
    this.satelliteLayer = false,
  }) : super(key: key);

  /// If true additional links required for the satellite layer will be
  /// displayed.
  final bool satelliteLayer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final List<Widget> links = <Widget>[
      RichText(
        text: TextSpan(
          text: '© Mapbox\n',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.https('www.mapbox.com', '/about/maps/'),
                  mode: LaunchMode.externalApplication);
            },
        ),
      ),
      RichText(
        text: TextSpan(
          text: '© OpenStreetMap\n',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.https('www.openstreetmap.org', '/copyright'),
                  mode: LaunchMode.externalApplication);
            },
        ),
      ),
      RichText(
        text: TextSpan(
          text: locale.improveData,
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.https('www.mapbox.com', '/map-feedback/'),
                  mode: LaunchMode.externalApplication);
            },
        ),
      ),
    ];
    if (satelliteLayer) {
      links.add(RichText(
        text: TextSpan(
          text: '\n© Maxar',
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(Uri.https('www.maxar.com'),
                  mode: LaunchMode.externalApplication);
            },
        ),
      ));
    }
    return Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onTap: () {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(locale.mapAttributionTitle('Mapbox')),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: links,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            child: Text(locale.ok.toUpperCase()),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ));
          },
          child: const SizedBox(
            height: 30,
            width: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.transparent),
            ),
          ),
        ));
  }
}
