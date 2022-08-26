import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../services/mapbox_geocoding.dart';
import '../search.dart';
import 'search_bar.dart';

class MapConfig {
  MapConfig(this.accessToken, {this.lastLocation});

  String accessToken;
  LatLng? lastLocation;

  static Future<MapConfig> create(AssetBundle assetBundle) async {
    final String accessToken =
        await assetBundle.loadString('assets/mapbox-access-token.txt');
    LatLng? lastLocation =
        await SharedPrefs.getLatLng(SharedPrefs.KEY_LAST_LOCATION);
    if (lastLocation != null) {
      lastLocation = null;
    }

    return MapConfig(accessToken, lastLocation: lastLocation);
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapboxMapController? mapController;
  MabboxTileset mapboxStyle = MabboxTileset.outdoor;
  LatLng? _lastLoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  void dispose() {
    //mapController?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  /*
  void _onSymbolTapped(Symbol symbol) {
    final LatLng? geometry = symbol.options.geometry;
    if (geometry != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(geometry));
      setState(() {
        _placeCardPreview = symbol.data!['place'] as Place?;
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(),
      body: FutureBuilder<MapConfig>(
          future: MapConfig.create(DefaultAssetBundle.of(context)),
          builder: (BuildContext context, AsyncSnapshot<MapConfig> snapshot) {
            final MapConfig? data = snapshot.data;
            if (snapshot.hasData && data != null) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: Stack(
                      children: <Widget>[
                        map(context, data),
                        /*
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, right: 16.0),
                            child: FloatingActionButton(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPressed: () async {
                                if (await Geolocator.checkPermission() ==
                                    LocationPermission.denied) {
                                  if (<LocationPermission>[
                                        LocationPermission.always,
                                        LocationPermission.whileInUse
                                      ].contains(await Geolocator
                                          .requestPermission()) ==
                                      false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                locale.errorNoPositionFound)));
                                  }
                                }
                                // TODO: Get Location
                                /*
                                final LatLng? loc = await mapController
                                    ?.requestMyLocationLatLng();
                                if (loc != null) {
                                  mapController?.moveCamera(
                                      CameraUpdate.newLatLngZoom(loc, 16.0));
                                }*/
                              },
                              // TODO(Xennis): Use Icons.location_disabled if location service is not avaiable.
                              child: const Icon(
                                Icons.location_searching,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),*/
                        SearchBar(
                          scaffoldKey: _scaffoldKey,
                          onSearchSubmitted: (String query) {
                            final Future<LatLng?> moveToLoc = Navigator.push(
                              context,
                              MaterialPageRoute<LatLng>(
                                  builder: (BuildContext context) => SearchPage(
                                        mapboxGeocodingGet(
                                            query, data.accessToken, _lastLoc),
                                      )),
                            );
                            moveToLoc.then((LatLng? value) {
                              if (value == null) {
                                return;
                              }
                              mapController?.moveCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: value, zoom: 16.0)));
                            });
                          },
                          onLayerToogle: () {
                            if (mapboxStyle == MabboxTileset.satellite) {
                              setState(() {
                                mapboxStyle = MabboxTileset.outdoor;
                              });
                            } else {
                              setState(() {
                                mapboxStyle = MabboxTileset.satellite;
                              });
                            }
                          },
                        ),
                      ],
                    )),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              log(snapshot.error.toString());
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget map(BuildContext context, MapConfig config) {
    return MapboxMap(
      accessToken: config.accessToken,
      onMapCreated: (MapboxMapController controller) {
        mapController = controller;
        //mapController!.onSymbolTapped.add(_onSymbolTapped);
        //onPositionChanged(mapController!.cameraPosition);
      },
      initialCameraPosition: CameraPosition(
          target: (config.lastLocation != null)
              ? config.lastLocation!
              : const LatLng(53.5519, 9.8682),
          zoom: 11.0),
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      styleString: mapboxStyle.id,
      trackCameraPosition: true,
      //onCameraIdle: () => onPositionChanged(mapController?.cameraPosition),
      onStyleLoadedCallback: () async {
        // TODO(Xennis): Use Icons.location_pin
        //final ByteData bytes = await rootBundle.load('assets/place-icon.png');
        //final Uint8List list = bytes.buffer.asUint8List();
        //mapController?.addImage('place-marker', list);
      },
      onUserLocationUpdated: (UserLocation location) {
        SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, location.position);
      },
    );
  }
}
