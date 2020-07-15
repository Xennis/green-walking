import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../types/place.dart';
import '../widgets/place_list_tile.dart';
import 'detail_footer.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key key, @required this.park})
      : assert(park != null),
        super(key: key);

  final Place park;

  // FIXME: Rework this and the functions below.
  Widget _description(PlaceExtract extract, String description) {
    if (extract == null) {
      if (description == null) {
        return Row();
      }
      // Use Wikidata description as fallback.
      return Text(
        description,
        style: const TextStyle(color: Colors.black),
      );
    }
    return RichText(
        textScaleFactor: 1.1,
        text: TextSpan(
            text: extract.text,
            style: const TextStyle(color: Colors.black, height: 1.5)));
  }

  Widget _location(String location) {
    if (location == null) {
      return Row();
    }
    return Text(
      location,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _title(BuildContext context, String name) {
    if (name == null) {
      return const Text('Unbekannt');
    }
    return Text(
      name,
      style: Theme.of(context).textTheme.headline4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _DetailSpeedDial(park),
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
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
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
                  _title(context, park.name),
                  _location(park.location),
                  CategoryChips(
                    categories: park.categories,
                    truncateCutoff: 25,
                  ),
                  _description(park.extract, park.description),
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
  const _DetailSpeedDial(this.park);

  final Place park;

  @override
  Widget build(BuildContext context) {
    final List<SpeedDialChild> children = <SpeedDialChild>[
      SpeedDialChild(
        onTap: () {
          launch(
              'geo:${park.coordinateLocation.latitude},${park.coordinateLocation.longitude}?q=${park.name}');
        },
        label: 'Maps',
        child: const Icon(Icons.map),
        backgroundColor: Colors.pinkAccent,
      ),
    ];
    if (park.wikipediaUrl != null) {
      children.add(SpeedDialChild(
        onTap: () {
          if (park.wikipediaUrl != null) {
            launch(park.wikipediaUrl);
          }
        },
        label: 'Wikipedia',
        child: const Icon(Icons.book),
        backgroundColor: Colors.greenAccent,
      ));
    }
    if (park.commonsUrl != null) {
      children.add(SpeedDialChild(
        onTap: () {
          if (park.commonsUrl != null) {
            launch(park.commonsUrl);
          }
        },
        label: 'Commons',
        child: const Icon(Icons.photo),
        backgroundColor: Colors.orangeAccent,
      ));
    }
    if (park.officialWebsite != null) {
      children.add(SpeedDialChild(
        onTap: () {
          if (park.officialWebsite != null) {
            launch(park.officialWebsite);
          }
        },
        label: 'Website',
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
