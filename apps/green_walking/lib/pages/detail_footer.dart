import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../types/place.dart';

class DetailFooter extends StatelessWidget {
  final String wikidataId;
  final PlaceImage image;
  final PlaceExtract extract;
  final String wikipediaUrl;

  DetailFooter(
      {@required this.wikidataId, this.image, this.extract, this.wikipediaUrl})
      : assert(wikidataId != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _Attribution(
        headline: 'Data',
        text: 'Powered by Wikidata',
        links: {
          'Powered by Wikidata\n': 'https://www.wikidata.org',
          'Improve this data': 'https://www.wikidata.org/wiki/$wikidataId',
        },
      )
    ];
    if (image != null) {
      children.add(_Attribution(
        headline: 'Foto',
        text: 'Foto: ${image.artist} / ${image.licenseShortName}',
        links: {
          '${image.artist}\n': image.descriptionUrl,
          '${image.licenseShortName}\n': image.licenseUrl,
          'Improve this data': image.descriptionUrl
        },
      ));
    }
    if (extract != null) {
      children.add(_Attribution(
        headline: 'Text',
        text: 'Text: Wikipedia / ${extract.licenseShortName}',
        links: {
          'Wikipedia\n': wikipediaUrl,
          '${extract.licenseShortName}\n': extract.licenseUrl,
          'Improve this data': wikipediaUrl
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
  final Color textColor = Colors.grey;

  final String text;
  final String headline;
  final Map<String, String> links;

  const _Attribution(
      {Key key,
      @required this.text,
      @required this.headline,
      @required this.links})
      : assert(text != null && headline != null && links != null),
        super(key: key);

  static List<Widget> _createLinkList(Map<String, String> links) {
    List<Widget> res = [];
    links.forEach((text, link) {
      if (link == null) {
        res.add(RichText(
            text: TextSpan(text: text, style: TextStyle(color: Colors.black))));
        return;
      }
      res.add(RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.blue),
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
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(this.headline),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: _createLinkList(links),
                    ),
                  ),
                  actions: [
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ));
      },
      child: Wrap(
        children: [
          RichText(
            textScaleFactor: 0.9,
            text: TextSpan(style: TextStyle(color: textColor), children: [
              TextSpan(text: "$text ", style: TextStyle(height: 1.5)),
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
