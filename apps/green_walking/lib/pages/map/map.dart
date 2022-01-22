import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_walking/pages/detail/detail.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/pages/search.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';
import 'package:green_walking/services/places.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/types/language.dart';
import 'package:green_walking/types/place.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../intl.dart';

class MapConfig {
  MapConfig(this.accessToken, {this.lastLocation});

  String accessToken;
  LatLng? lastLocation;

  static Future<MapConfig> create(AssetBundle assetBundle) async {
    await FirebaseAuth.instance.signInAnonymously();
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
  GeoHash? _lastGeohash;
  MabboxTileset mapboxStyle = MabboxTileset.outdoor;
  LatLng? _lastLoc;
  Place? _placeCardPreview;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  void dispose() {
    mapController?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  void _onSymbolTapped(Symbol symbol) {
    final LatLng? geometry = symbol.options.geometry;
    if (geometry != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(geometry));
      setState(() {
        _placeCardPreview = symbol.data!['place'] as Place?;
      });
    }
  }

  void onPositionChanged(CameraPosition? position) {
    if (position == null) {
      return;
    }
    if (position.zoom < 11.0) {
      // clearSymbols does not work https://github.com/tobrun/flutter-mapbox-gl/issues/651
      mapController?.removeSymbols(mapController!.symbols);
      _lastGeohash = null;
      return;
    }

    final GeoHash _newGeohash = GeoHash.fromDecimalDegrees(
        position.target.longitude, position.target.latitude,
        precision: 4);
    if (_lastGeohash != null && _lastGeohash!.contains(_newGeohash.geohash)) {
      return;
    }
    _lastGeohash = _newGeohash;

    final Language lang =
        languageFromString(AppLocalizations.of(context).localeName);

    nearbyPlaces(_newGeohash, lang).then((List<Place> value) {
      final List<SymbolOptions> options = value
          .map((Place p) => SymbolOptions(
                geometry: p.geopoint,
                iconImage: 'place-marker',
                iconSize: 0.5,
                iconAnchor: 'top',
                // TODO(Xennis): Use different colors
                //iconColor: '#${placeTypeToColor(p.type).value.toRadixString(16)}'
              ))
          .toList();
      final List<Map<String, Place>> data =
          value.map((Place p) => <String, Place>{'place': p}).toList();
      // clearSymbols does not work https://github.com/tobrun/flutter-mapbox-gl/issues/651
      mapController?.removeSymbols(mapController!.symbols);
      mapController?.addSymbols(options, data);

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
            final MapConfig? data = snapshot.data;
            if (snapshot.hasData && data != null) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: Stack(
                      children: <Widget>[
                        map(context, data),
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
                                final LatLng? loc = await mapController
                                    ?.requestMyLocationLatLng();
                                if (loc != null) {
                                  mapController?.moveCamera(
                                      CameraUpdate.newLatLngZoom(loc, 16.0));
                                }
                              },
                              // TODO(Xennis): Use Icons.location_disabled if location service is not avaiable.
                              child: const Icon(
                                Icons.location_searching,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          top: true,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 7, 15, 0),
                            child: searchBar(context, data.accessToken),
                          ),
                        ),
                      ],
                    )),
                    Visibility(
                      visible: _placeCardPreview != null,
                      child: placeCardPreview(),
                    )
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

  Widget placeCardPreview() {
    final AppLocalizations locale = AppLocalizations.of(context);
    final TextStyle tx =
        TextStyle(color: Theme.of(context).colorScheme.secondary);
    final Place? place = _placeCardPreview;
    if (place == null) {
      return Container();
    }

    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PlaceListTile(
              place,
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text(locale.ok.toUpperCase(), style: tx),
                  onPressed: () {
                    setState(() {
                      _placeCardPreview = null;
                    });
                  },
                ),
                TextButton(
                  child: Text(locale.details.toUpperCase(), style: tx),
                  onPressed: () {
                    //if (p == null) {
                    //  log('no park found');
                    //  return;
                    //}
                    Navigator.of(context)
                        .push<dynamic>(MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => DetailPage(
                        place,
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
  }

  Widget searchBar(BuildContext context, String accessToken) {
    final AppLocalizations locale = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.menu,
                semanticLabel:
                    MaterialLocalizations.of(context).openAppDrawerTooltip),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
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
                final Future<LatLng?> moveToLoc = Navigator.push(
                  context,
                  MaterialPageRoute<LatLng>(
                      builder: (BuildContext context) => SearchPage(
                            mapboxGeocodingGet(query, accessToken, _lastLoc),
                          )),
                );
                moveToLoc.then((LatLng? value) {
                  if (value == null) {
                    return;
                  }
                  mapController?.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: value, zoom: 16.0)));
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
        mapController!.onSymbolTapped.add(_onSymbolTapped);
        onPositionChanged(mapController!.cameraPosition);
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
      onCameraIdle: () => onPositionChanged(mapController?.cameraPosition),
      onStyleLoadedCallback: () async {
        // TODO(Xennis): Use Icons.location_pin
        final ByteData bytes = await rootBundle.load('assets/place-icon.png');
        final Uint8List list = bytes.buffer.asUint8List();
        mapController?.addImage('place-marker', list);
      },
      onUserLocationUpdated: (UserLocation location) {
        SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, location.position);
      },
    );
  }
}
