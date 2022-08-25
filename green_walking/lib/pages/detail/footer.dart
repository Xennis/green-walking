import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../types/place.dart';

class DetailFooter extends StatelessWidget {
  const DetailFooter(this.wikidataId,
      {Key? key, @required this.image, this.extract})
      : super(key: key);

  final String wikidataId;
  final PlaceImage? image;
  final PlaceExtract? extract;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final List<Widget> children = <Widget>[
      _Attribution(
        locale.poweredBy('Wikidata'),
        locale.metaDataAttributionTitle,
        <String, String>{
          '${locale.poweredBy('Wikidata')}\n': 'https://www.wikidata.org',
          locale.improveData: 'https://www.wikidata.org/wiki/$wikidataId',
        },
      )
    ];
    final PlaceImage? img = image;
    final String? descriptionUrl = image?.descriptionUrl;
    if (img != null && descriptionUrl != null) {
      children.add(_Attribution(
        '${locale.image}: ${img.artist} / ${img.licenseShortName}',
        locale.image,
        <String?, String?>{
          '${img.artist}\n': descriptionUrl,
          '${img.licenseShortName}\n': img.licenseUrl,
          locale.improveData: img.descriptionUrl
        },
      ));
    }
    final PlaceExtract? ext = extract;
    if (ext != null && ext.text != null) {
      children.add(_Attribution(
        '${locale.text}: Wikipedia / ${ext.licenseShortName}',
        locale.text,
        <String, String?>{
          'Wikipedia\n': ext.url,
          '${ext.licenseShortName}\n': ext.licenseUrl,
          locale.improveData: ext.url
        },
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution(this.text, this.headline, this.links,
      {Key? key, this.textColor = Colors.grey})
      : super(key: key);

  final String text;
  final String headline;
  final Map<String?, String?> links;
  final Color textColor;

  static List<Widget> _createLinkList(Map<String?, String?> links) {
    final List<Widget> res = <Widget>[];
    links.forEach((String? text, String? link) {
      if (text == null) {
        return;
      }
      if (link == null) {
        res.add(RichText(
            text: TextSpan(
                text: text, style: const TextStyle(color: Colors.black))));
        return;
      }
      res.add(RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()..onTap = () => launch(link),
        ),
      ));
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(headline),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: _createLinkList(links),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: Text(locale.ok.toUpperCase()),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ));
      },
      child: Wrap(
        children: <Widget>[
          RichText(
            textScaleFactor: 0.9,
            text: TextSpan(
                style: TextStyle(color: textColor),
                children: <InlineSpan>[
                  TextSpan(text: '$text ', style: const TextStyle(height: 1.5)),
                  WidgetSpan(
                      child: Icon(
                    Icons.info,
                    size: 15,
                    color: textColor,
                    semanticLabel: locale.attributionInfoSemanticLabel,
                  ))
                ]),
          ),
        ],
      ),
    );
  }
}
