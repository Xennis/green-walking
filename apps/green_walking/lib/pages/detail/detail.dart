import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../core.dart';
import '../../intl.dart';
import '../../types/place.dart';
import '../../widgets/place_list_tile.dart';
import 'footer.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key key, @required this.park})
      : assert(park != null),
        super(key: key);

  final Place park;

  // FIXME: Rework this and the functions below.
  Widget _location(String location) {
    if (location == null) {
      return Container();
    }
    return Text(
      truncateString(location, 80),
      style: const TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _DetailSpeedDial(park: park),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          Widget fs;
          final String imageUrl = park.image?.url;
          if (imageUrl != null) {
            fs = FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: park.image?.url,
                fit: BoxFit.cover,
              ),
            );
          }
          return <Widget>[
            SliverAppBar(
              expandedHeight: imageUrl != null ? 200.0 : null,
              floating: false,
              pinned: false,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  semanticLabel:
                      MaterialLocalizations.of(context).backButtonTooltip,
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              flexibleSpace: fs,
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Name(name: park.name),
                  _location(park.location),
                  CategoryChips(
                    categories: park.categories,
                    truncateCutoff: 25,
                  ),
                  _Description(
                      extract: park.extract, description: park.description),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Padding(
                // Wide right padding because of floating action button.
                padding: const EdgeInsets.fromLTRB(15, 25, 85, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DetailFooter(
                      wikidataId: park.wikidataId,
                      image: park.image,
                      extract: park.extract,
                      wikipediaUrl: park.wikipediaUrl,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DetailSpeedDial extends StatelessWidget {
  const _DetailSpeedDial({Key key, @required this.park})
      : assert(park != null),
        super(key: key);

  final Place park;

  @override
  Widget build(BuildContext context) {
    final List<SpeedDialChild> children = <SpeedDialChild>[
      SpeedDialChild(
        onTap: () {
          String uri =
              'geo:${park.geopoint.latitude},${park.geopoint.longitude}';
          if (park.name != null) {
            uri += '?q=${park.name}';
          }
          launch(uri);
        },
        label: AppLocalizations.of(context).maps,
        child: const Icon(Icons.map),
        backgroundColor: Colors.pinkAccent,
      ),
    ];
    if (park.wikipediaUrl != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(park.wikipediaUrl),
        label: 'Wikipedia',
        child: const Icon(Icons.book),
        backgroundColor: Colors.greenAccent,
      ));
    }
    if (park.commonsUrl != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(park.commonsUrl),
        label: 'Commons',
        child: const Icon(Icons.photo),
        backgroundColor: Colors.orangeAccent,
      ));
    }
    if (park.officialWebsite != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(park.officialWebsite),
        label: AppLocalizations.of(context).website,
        child: const Icon(Icons.web),
        backgroundColor: Colors.blueAccent,
      ));
    }
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).accentColor,
        children: children);
  }
}

class _Name extends StatelessWidget {
  const _Name({Key key, this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    String text = AppLocalizations.of(context).nameless;
    if (name != null) {
      text = name;
    }
    return Text(
      truncateString(text, 50),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({Key key, this.extract, this.description})
      : super(key: key);

  final PlaceExtract extract;
  final String description;

  @override
  Widget build(BuildContext context) {
    String text;
    if (extract?.text != null) {
      text = extract.text;
    } else if (description != null) {
      // Use Wikidata description as fallback.
      text = description;
    } else {
      text = AppLocalizations.of(context).website;
    }
    return RichText(
        textScaleFactor: 1.1,
        text: TextSpan(
            text: text,
            style: const TextStyle(color: Colors.black, height: 1.5)));
  }
}
