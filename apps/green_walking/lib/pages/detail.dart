import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../services/parks.dart';
import '../types/place.dart';
import '../widgets/place_list_tile.dart';

class DetailPageArguments {
  final LatLng coordinates;

  DetailPageArguments(this.coordinates);
}

class DetailPage extends StatelessWidget {
  // FIXME: Rework this and the functions below.
  Widget _description(String description) {
    if (description == null) {
      return Row();
    }
    return Text(description);
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

  Widget _image(PlaceImage image) {
    if (image == null) {
      return Row();
    }
    if (image.url == null) {
      return Row();
    }
    return Image.network(image.url);
  }

  Widget _imageAttribution(BuildContext context, PlaceImage image) {
    if (image == null) {
      return Row();
    }
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Foto'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: '${image.artist}\n',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(image.descriptionUrl);
                              },
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '${image.licenseShortName}\n',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(image.licenseUrl);
                              },
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Improve this data',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(image.descriptionUrl);
                              },
                          ),
                        )
                      ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Foto: ${image.artist} / ${image.licenseShortName}",
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.info,
                size: 14,
                color: Colors.grey,
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DetailPageArguments args = ModalRoute.of(context).settings.arguments;
    final Place park = ParkService.get(args.coordinates);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(park.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      floatingActionButton: _DetailSpeedDial(park),
      body: Column(
        children: [
          _image(park.image),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _location(park.location),
                  CategoryChips(park.categories),
                  // TODO: Add Wikipedia quote instead
                  _description(park.description),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Data'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: 'Powered by Wikidata\n',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launch(
                                                  'https://www.wikidata.org');
                                            },
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Improve this data',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launch(
                                                  'https://www.wikidata.org/wiki/${park.wikidataId}');
                                            },
                                        ),
                                      ),
                                    ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Powered by Wikidata ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(
                              Icons.info,
                              size: 14,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  _imageAttribution(context, park.image),
                ],
              )),
        ],
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
        backgroundColor: Colors.blueAccent,
        children: children);
  }
}
