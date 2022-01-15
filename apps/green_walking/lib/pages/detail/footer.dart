import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../intl.dart';
import '../../types/place.dart';

class DetailFooter extends StatelessWidget {
  const DetailFooter(
      {Key key, @required this.wikidataId, this.image, this.extract})
      : assert(wikidataId != null),
        super(key: key);

  final String wikidataId;
  final PlaceImage image;
  final PlaceExtract extract;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
    final List<Widget> children = <Widget>[
      _Attribution(
        headline: locale.metaDataAttributionTitle,
        text: locale.poweredBy('Wikidata'),
        links: <String, String>{
          '${locale.poweredBy('Wikidata')}\n': 'https://www.wikidata.org',
          locale.improveData: 'https://www.wikidata.org/wiki/$wikidataId',
        },
      )
    ];
    if (image?.descriptionUrl != null) {
      children.add(_Attribution(
        headline: locale.image,
        text: '${locale.image}: ${image.artist} / ${image.licenseShortName}',
        links: <String, String>{
          '${image.artist}\n': image.descriptionUrl,
          '${image.licenseShortName}\n': image.licenseUrl,
          locale.improveData: image.descriptionUrl
        },
      ));
    }
    if (extract?.text != null) {
      children.add(_Attribution(
        headline: locale.text,
        text: '${locale.text}: Wikipedia / ${extract.licenseShortName}',
        links: <String, String>{
          'Wikipedia\n': extract.url,
          '${extract.licenseShortName}\n': extract.licenseUrl,
          locale.improveData: extract.url
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
  const _Attribution(
      {Key key,
      @required this.text,
      @required this.headline,
      @required this.links,
      this.textColor = Colors.grey})
      : assert(text != null && headline != null && links != null),
        super(key: key);

  final String text;
  final String headline;
  final Map<String, String> links;
  final Color textColor;

  static List<Widget> _createLinkList(Map<String, String> links) {
    final List<Widget> res = <Widget>[];
    links.forEach((String text, String link) {
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
    final AppLocalizations locale = AppLocalizations.of(context);
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
