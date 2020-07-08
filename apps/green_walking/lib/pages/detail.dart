import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../types/place.dart';
import '../widgets/place_list_tile.dart';

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

  Widget _title(String name) {
    if (name == null) {
      return Text("Unbekannt");
    }
    return Text(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: _title(park.name),
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
                  _DetailAttribution(park.wikidataId, park.image),
                ],
              )),
        ],
      ),
    );
  }
}

class _DetailAttribution extends StatelessWidget {
  final String wikidataId;
  final PlaceImage image;
  final Color textColor = Colors.grey;

  _DetailAttribution(this.wikidataId, this.image);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [_wikidata(context)];
    if (image != null) {
      children.add(_imageAttribution(context, image));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _wikidata(BuildContext context) {
    return GestureDetector(
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
                                launch('https://www.wikidata.org');
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
                                    'https://www.wikidata.org/wiki/$wikidataId');
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
      child: Wrap(
        children: [
          RichText(
            text: TextSpan(style: TextStyle(color: textColor), children: [
              TextSpan(
                text: "Powered by Wikidata",
              ),
              TextSpan(text: " "),
              WidgetSpan(
                child: Icon(
                  Icons.info,
                  size: 15,
                  color: textColor,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _imageAttribution(BuildContext context, PlaceImage image) {
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
      child: Wrap(
        children: [
          RichText(
            text: TextSpan(style: TextStyle(color: textColor), children: [
              TextSpan(
                text: "Foto: ${image.artist} / ${image.licenseShortName}",
              ),
              TextSpan(text: " "),
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
