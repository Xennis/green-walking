import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../types/place.dart';

class DetailFooter extends StatelessWidget {
  const DetailFooter(
      {@required this.wikidataId, this.image, this.extract, this.wikipediaUrl})
      : assert(wikidataId != null);

  final String wikidataId;
  final PlaceImage image;
  final PlaceExtract extract;
  final String wikipediaUrl;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      _Attribution(
        headline: 'Daten',
        text: 'Powered by Wikidata',
        links: <String, String>{
          'Powered by Wikidata\n': 'https://www.wikidata.org',
          'Verbessere diese Daten': 'https://www.wikidata.org/wiki/$wikidataId',
        },
      )
    ];
    if (image != null) {
      children.add(_Attribution(
        headline: 'Foto',
        text: 'Foto: ${image.artist} / ${image.licenseShortName}',
        links: <String, String>{
          '${image.artist}\n': image.descriptionUrl,
          '${image.licenseShortName}\n': image.licenseUrl,
          'Verbessere diese Daten': image.descriptionUrl
        },
      ));
    }
    if (extract != null && extract.text != null) {
      children.add(_Attribution(
        headline: 'Text',
        text: 'Text: Wikipedia / ${extract.licenseShortName}',
        links: <String, String>{
          'Wikipedia\n': wikipediaUrl,
          '${extract.licenseShortName}\n': extract.licenseUrl,
          'Verbessere diese Daten': wikipediaUrl
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
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(link);
            },
        ),
      ));
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
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
                    FlatButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
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
                  ))
                ]),
          ),
        ],
      ),
    );
  }
}
