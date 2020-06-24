import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/map_attribution.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController;
  MapOptions mapOptions = MapOptions(
    center: LatLng(53.5519, 9.8682),
    zoom: 15.0,
    plugins: [
      AttributionPlugin(),
    ],
    minZoom: 6,
    maxZoom: 18,
    swPanBoundary: LatLng(46.1037, 5.2381),
    nePanBoundary: LatLng(55.5286, 16.6275),
  );
  Future<String> accessToken;

  List<CircleMarker> circles = [];

  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    mapController = MapController();
    accessToken = DefaultAssetBundle.of(context)
        .loadString("assets/mapbox-access-token.txt");
    super.initState();
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
        log(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Green Walking'),
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
                      options: mapOptions,
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
                        AttributionOptions(),
                      ]),
                )
              ]));
            }
            return Center(child: CircularProgressIndicator());
          }),
      // A Builder is used because the Scaffold context is needed for the SnakBars.
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
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
                  if (mapOptions.isOutOfBounds(newPos)) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Location outside of Germany"),
                    ));
                    return;
                  }

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
