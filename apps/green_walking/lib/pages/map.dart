import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:green_walking/services/parks.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:latlong/latlong.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes.dart';
import '../widgets/map_attribution.dart';
import '../types/place.dart';
import 'detail.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PopupController _popupController = PopupController();
  MapController mapController;
  Future<String> accessToken;

  List<Marker> markers = [];
  List<CircleMarker> circles = [];

  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    mapController = MapController();
    accessToken = DefaultAssetBundle.of(context)
        .loadString("assets/mapbox-access-token.txt");
    super.initState();

    ParkService.load(context).then((value) {
      List<Marker> l = [];
      for (final p in value) {
        l.add(Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 50,
          width: 50,
          point: p.coordinates,
          builder: (_) => Icon(
            Icons.nature_people,
            color: Colors.blueGrey,
            size: 50,
          ),
        ));
      }
      setState(() {
        markers = l;
      });
    });

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = true
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        log(e.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2;
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: 'To see the source code of this app, please visit the '),
            TextSpan(
              text: 'GitHub repository',
              style: TextStyle(color: Theme.of(context).accentColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch('https://github.com/Xennis/green-walking');
                },
            ),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Green Walking'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(children: <Widget>[
                Row(children: [
                  Text(
                    'Green Walking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ]),
                Row(
                  children: [
                    Text("Entdecke deine grüne Stadt!", style: TextStyle(color: Colors.white70,)),
                  ],
                )
              ]),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Einstellungen'),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Hilfe'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback senden'),
            ),
            AboutListTile(
              icon: Icon(Icons.info),
              applicationIcon: FlutterLogo(),
              applicationName: 'Green Walking',
              applicationVersion: 'Version 0.1.0',
              applicationLegalese: 'Developed by Xennis',
              aboutBoxChildren: aboutBoxChildren,
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
          future: accessToken,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Row(children: [
                Flexible(
                  child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(53.5519, 9.8682),
                        zoom: 15.0,
                        plugins: [
                          MarkerClusterPlugin(),
                          AttributionPlugin(),
                        ],
                        minZoom: 6,
                        maxZoom: 18,
                        swPanBoundary: LatLng(46.1037, 5.2381),
                        nePanBoundary: LatLng(55.5286, 16.6275),
                        onTap: (_) => _popupController.hidePopup(),
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken': snapshot.data,
                            'id': 'outdoors-v11',
                          },
                          // It is recommended to use TileProvider with a caching and retry strategy, like
                          // NetworkTileProvider or CachedNetworkTileProvider
                          tileProvider: NetworkTileProvider(),
                        ),
                        CircleLayerOptions(
                          circles: circles,
                        ),
                        MarkerClusterLayerOptions(
                          size: Size(40, 40),
                          markers: markers,
                          builder: (context, markers) {
                            // Avoid using a FloatingActionButton here.
                            // See https://github.com/lpongetti/flutter_map_marker_cluster/issues/18
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  markers.length.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          popupOptions: PopupOptions(
                              popupSnap: PopupSnap.top,
                              popupController: _popupController,
                              popupBuilder: (_, marker) {
                                final Place p = ParkService.get(marker.point);
                                return Container(
                                  width: 300,
                                  //alignment: Alignment.bottomLeft,
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        PlaceListTile(
                                          place: p,
                                        ),
                                        ButtonBar(
                                          children: <Widget>[
                                            FlatButton(
                                              child: const Text('OK'),
                                              onPressed: () =>
                                                  _popupController.hidePopup(),
                                            ),
                                            FlatButton(
                                              child: const Text('DETAILS'),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    Routes.detail,
                                                    arguments:
                                                        DetailPageArguments(
                                                            p.coordinates));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        AttributionOptions(
                            logoAssetName: "assets/mapbox-logo.svg"),
                      ]),
                )
              ]));
            }
            return Center(child: CircularProgressIndicator());
          }),
      // A Builder is used because the Scaffold context is needed for the SnakBars.
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          heroTag: "location-searching",
          child: Icon(Icons.location_searching),
          onPressed: () {
            Geolocator().checkGeolocationPermissionStatus().then((status) {
              if (status != GeolocationStatus.granted) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Permission denied"),
                ));
                log("no access granted");
                log(status.toString());
                return;
              }
              Geolocator().isLocationServiceEnabled().then((enabled) {
                if (enabled != true) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content:
                                Text("To continue, turn on device location"),
                            actions: [
                              FlatButton(
                                child: Text("NO THANKS"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    AppSettings.openLocationSettings();
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ));

                  log("location disabled");
                  log(_lastKnownPosition.toString());
                  log(_currentPosition.toString());
                  return;
                }

                log(_lastKnownPosition.toString());
                log(_currentPosition.toString());
                if (_currentPosition != null) {
                  log("current post");
                  LatLng newPos = LatLng(
                      _currentPosition.latitude, _currentPosition.longitude);
                  // FIXME: Check the location is inside the bounds.
                  //if (!mapController.bounds.contains(newPos)) {
                  //  Scaffold.of(context).showSnackBar(SnackBar(
                  //    content: Text("Location outside of Germany"),
                  //  ));
                  //  return;
                  //}

                  mapController.move(newPos, 15.0);
                  setState(() {
                    circles = [
                      CircleMarker(
                        point: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        color: Colors.blueAccent,
                        radius: 10.0,
                      )
                    ];
                  });
                } else if (_initLastKnownLocation() != null) {
                  mapController.move(
                      LatLng(_lastKnownPosition.latitude,
                          _lastKnownPosition.longitude),
                      15.0);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Use last location"),
                  ));
                } else {
                  log("current and last location are null");
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("No location yet"),
                  ));
                }
              }).catchError((onError) {
                log("isLocationServiceEnabled onError");
                log(onError.toString());
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("isLocationServiceEnabled failed"),
                ));
              });
            }).catchError((onError) {
              log("checkGeolocationPermissionStatus onError");
              log(onError.toString());
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("checkGeolocationPermissionStatus failed"),
              ));
            });
          },
        ),
      ),
    );
  }
}
