import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/pages/search.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';
import 'package:green_walking/services/places.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/types/language.dart';
import 'package:green_walking/types/place.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../intl.dart';

class MapConfig {
  MapConfig({this.accessToken, this.lastLocation});

  String accessToken;
  LatLng lastLocation;

  static Future<MapConfig> create(AssetBundle assetBundle) async {
    await FirebaseAuth.instance.signInAnonymously();
    final String accessToken =
        await assetBundle.loadString('assets/mapbox-access-token.txt');
    LatLng lastLocation =
        await SharedPrefs.getLatLng(SharedPrefs.KEY_LAST_LOCATION);
    if (lastLocation != null) {
      lastLocation = null;
    }

    return MapConfig(accessToken: accessToken, lastLocation: lastLocation);
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MapboxMapController mapController;
  GeoHash _lastGeohash;
  MabboxTileset mapboxStyle = MabboxTileset.outdoor;
  LatLng _lastLoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  void dispose() {
    mapController?.onSymbolTapped?.remove(_onSymbolTapped);
    super.dispose();
  }

  void _onSymbolTapped(Symbol symbol) {
    mapController
        ?.animateCamera(CameraUpdate.newLatLng(symbol.options.geometry));
  }

  void onPositionChanged(LatLng center) {
    if (center == null) {
      return;
    }

    final GeoHash _newGeohash = GeoHash.fromDecimalDegrees(
        center.longitude, center.latitude,
        precision: 4);
    if (_lastGeohash != null && _lastGeohash.contains(_newGeohash.geohash)) {
      return;
    }
    _lastGeohash = _newGeohash;

    final Language lang =
        languageFromString(AppLocalizations.of(context).localeName);

    nearbyPlaces(_newGeohash, lang).then((List<Place> value) {
      final List<SymbolOptions> markers = value
          .map((Place p) => SymbolOptions(
                geometry: p.geopoint,
                iconImage: 'place-marker',
                iconSize: 0.5,
                iconAnchor: 'top',
                // TODO(Xennis): Use different colors
                //iconColor: '#${placeTypeToColor(p.type).value.toRadixString(16)}'
              ))
          .toList();
      mapController.clearSymbols();
      mapController.addSymbols(markers);

      setState(() {
        _lastGeohash = _newGeohash;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(),
      body: FutureBuilder<MapConfig>(
          future: MapConfig.create(DefaultAssetBundle.of(context)),
          builder: (BuildContext context, AsyncSnapshot<MapConfig> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  Center(
                      child: Row(children: <Widget>[
                    Flexible(
                      child: map(context, snapshot.data),
                    )
                  ])),
                  Positioned(
                    top: 37,
                    right: 15,
                    left: 15,
                    child: searchBar(context, snapshot.data.accessToken),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              log(snapshot.error.toString());
            }

            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () async {
          if (await Geolocator.checkPermission() == LocationPermission.denied) {
            if (<LocationPermission>[
                  LocationPermission.always,
                  LocationPermission.whileInUse
                ].contains(await Geolocator.requestPermission()) ==
                false) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(locale.errorNoPositionFound)));
            }
          }

          mapController.moveCamera(CameraUpdate.newLatLngZoom(
              await mapController.requestMyLocationLatLng(), 15.0));
        },
        // TODO(Xennis): Use Icons.location_disabled if location service is not avaiable.
        child: const Icon(
          Icons.location_searching,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context, String accessToken) {
    final AppLocalizations locale = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.menu,
                semanticLabel:
                    MaterialLocalizations.of(context).openAppDrawerTooltip),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintText: locale.searchBoxHintLabel('...')),
              onSubmitted: (String query) {
                final Future<LatLng> moveToLoc = Navigator.push(
                  context,
                  MaterialPageRoute<LatLng>(
                      builder: (BuildContext context) => SearchPage(
                            result: mapboxGeocodingGet(
                                query, accessToken, _lastLoc),
                          )),
                );
                moveToLoc.then((LatLng value) {
                  if (value == null) {
                    return;
                  }
                  mapController?.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: value, zoom: 14.0)));
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              splashColor: Colors.grey,
              icon: Icon(
                Icons.layers,
                semanticLabel: locale.mapSwitchLayerSemanticLabel,
              ),
              onPressed: () {
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
          ),
        ],
      ),
    );
  }

  Widget map(BuildContext context, MapConfig config) {
    //final AppLocalizations locale = AppLocalizations.of(context);
    return MapboxMap(
      accessToken: config.accessToken,
      onMapCreated: (MapboxMapController controller) {
        mapController = controller;
        mapController.onSymbolTapped.add(_onSymbolTapped);
      },
      initialCameraPosition: CameraPosition(
          target: (config.lastLocation != null)
              ? config.lastLocation
              : const LatLng(53.5519, 9.8682),
          zoom: 11.0),
      myLocationEnabled: true,
      rotateGesturesEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(11.0, 18.0),
      styleString: mapboxStyle.id,
      onCameraIdle: () =>
          onPositionChanged(mapController.cameraPosition.target),
      onStyleLoadedCallback: () async {
        // TODO(Xennis): Use Icons.location_pin
        final ByteData bytes = await rootBundle.load('assets/place-icon.png');
        final Uint8List list = bytes.buffer.asUint8List();
        mapController.addImage('place-marker', list);
      },
      onUserLocationUpdated: (UserLocation location) {
        if (location == null || location.position == null) {
          _lastLoc = null;
          return;
        }
        SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, location.position);
      },
    );

    /*
          MarkerClusterLayerOptions(
            size: const Size(40, 40),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(100),
            ),
            markers: places,
            builder: (BuildContext context, List<Marker> markers) {
              // Avoid using a FloatingActionButton here.
              // See https://github.com/lpongetti/flutter_map_marker_cluster/issues/18
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            popupOptions: PopupOptions(
                popupSnap: PopupSnap.markerTop,
                popupController: _popupController,
                popupBuilder: (_, Marker marker) {
                  final Place p = (marker as PlaceMarker).place;
                  final TextStyle tx =
                      TextStyle(color: Theme.of(context).colorScheme.secondary);
                  return Container(
                    width: 300,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          PlaceListTile(
                            place: p,
                          ),
                          ButtonBar(
                            children: <Widget>[
                              TextButton(
                                child: Text(locale.ok.toUpperCase(), style: tx),
                                onPressed: () => _popupController.hidePopup(),
                              ),
                              TextButton(
                                child: Text(locale.details.toUpperCase(),
                                    style: tx),
                                onPressed: () {
                                  if (p == null) {
                                    log('no park found');
                                    return;
                                  }
                                  Navigator.of(context)
                                      .push<dynamic>(MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        DetailPage(
                                      park: p,
                                    ),
                                  ));
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
        ]);*/
  }
}
