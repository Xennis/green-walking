import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../types/place.dart';
import '../widgets/place_list_tile.dart';
import 'detail_footer.dart';

class DetailPageArguments {
  final Place place;

  DetailPageArguments(this.place);
}

class DetailPage extends StatelessWidget {
  final Place park;

  DetailPage({Key key, @required this.park})
      : assert(park != null),
        super(key: key);

  // FIXME: Rework this and the functions below.
  Widget _description(PlaceExtract extract, String description) {
    if (extract == null) {
      if (description == null) {
        return Row();
      }
      // Use Wikidata description as fallback.
      return Text(
        description,
        style: TextStyle(color: Colors.black),
      );
    }
    return RichText(
        textScaleFactor: 1.1,
        text: TextSpan(
            text: extract.text,
            style: TextStyle(color: Colors.black, height: 1.5)));
  }

  Widget _location(String location) {
    if (location == null) {
      return Row();
    }
    return Text(
      location,
      style: TextStyle(color: Colors.grey),
    );
  }

  Widget _title(BuildContext context, String name) {
    if (name == null) {
      return Text("Unbekannt");
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
          String imageUrl = park.image?.url;
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
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              flexibleSpace: fs,
            )
          ];
        },
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Padding(
                // Wide right padding because of floating action button.
                padding: EdgeInsets.fromLTRB(15, 25, 85, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailFooter(
                      wikidataId: park.wikidataId,
                      image: park.image,
                      extract: park.extract,
                      wikipediaUrl: park.wikipediaUrl,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _DetailSpeedDial extends StatelessWidget {
  final Place park;

  _DetailSpeedDial(this.park);

  @override
  Widget build(BuildContext context) {
    List<SpeedDialChild> children = [
      SpeedDialChild(
        onTap: () {
          launch(
              'geo:${park.coordinateLocation.latitude},${park.coordinateLocation.longitude}?q=${park.name}');
        },
        label: 'Maps',
        child: Icon(Icons.map),
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
        child: Icon(Icons.book),
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
        child: Icon(Icons.photo),
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
        child: Icon(Icons.web),
        backgroundColor: Colors.blueAccent,
      ));
    }
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).accentColor,
        children: children);
  }
}
