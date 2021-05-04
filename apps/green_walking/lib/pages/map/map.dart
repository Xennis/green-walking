import 'dart:async';
import 'dart:developer';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/pages/search.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';
import 'package:green_walking/services/places.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/types/language.dart';
import 'package:green_walking/types/marker.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:latlong/latlong.dart';

import '../../core.dart';
import '../../intl.dart';
import '../../types/place.dart';
import '../detail/detail.dart';
import 'attribution.dart';

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
  final MapController mapController = MapController();
  final PopupController _popupController = PopupController();
  // (south-west, north-east)
  List<PlaceMarker> places = <PlaceMarker>[];
  List<Marker> userLocationMarkers = <Marker>[];
  GeoHash _lastGeohash;
  MabboxTileset mapboxStyle = MabboxTileset.outdoor;
  LatLng _lastLoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  void onPositionChanged(MapPosition position, bool hasGesture) {
    final LatLng center = position.center;
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

    PlaceService.nearby(_newGeohash, lang).then((List<Place> value) {
      setState(() {
        places = value
            .map((Place p) => PlaceMarker(
                  place: p,
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  height: 50,
                  width: 50,
                  point: p.geopoint,
                  builder: (_) => Icon(
                    Icons.location_on,
                    color: placeTypeToColor(p.type),
                    size: 50,
                  ),
                ))
            .toList();
        _lastGeohash = _newGeohash;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            result: MapboxGeocoding.get(
                                query, accessToken, _lastLoc),
                          )),
                );
                moveToLoc.then((LatLng value) {
                  if (value == null) {
                    return;
                  }
                  mapController.move(value, 14.0);
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
    final AppLocalizations locale = AppLocalizations.of(context);
    return FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: (config.lastLocation != null)
              ? config.lastLocation
              : LatLng(53.5519, 9.8682),
          zoom: 14.0,
          plugins: <MapPlugin>[
            AttributionPlugin(),
            MarkerClusterPlugin(),
            LocationPlugin(),
          ],
          minZoom: 11, // zoom out
          maxZoom: 18, // zoom in
          onTap: (_) => _popupController.hidePopup(),
          onPositionChanged: onPositionChanged,
        ),
        layers: <LayerOptions>[
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/${mapboxStyle.id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: <String, String>{
              'accessToken': config.accessToken,
              // Use if https://github.com/fleaflet/flutter_map/pull/740/ is merged.
              //'id': mapboxStyle,
            },
            tileProvider: NetworkTileProvider(),
            overrideTilesWhenUrlChanges: true,
          ),
          // Before MarkerClusterLayerOptions. Otherwise the user location is on top of markers
          // and especially on top of pop-ups.
          MarkerLayerOptions(markers: userLocationMarkers),
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
                  color: Theme.of(context).accentColor,
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
                      TextStyle(color: Theme.of(context).accentColor);
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
          LocationOptions(
            markers: userLocationMarkers,
            onLocationUpdate: (LatLngData ld) {
              if (ld == null) {
                _lastLoc = null;
                return;
              }
              _lastLoc = ld.location;
              SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, ld.location);
            },
            onLocationRequested: (LatLngData ld) {
              final LatLng loca = ld?.location;
              if (loca == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(locale.errorNoPositionFound)));
              } else {
                mapController.move(loca, 15.0);
              }
            },
            buttonBuilder: (BuildContext context,
                ValueNotifier<LocationServiceStatus> status,
                Function onPressed) {
              return Align(
                // The "right" has not really an affect here.
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FloatingActionButton(
                            child:
                                ValueListenableBuilder<LocationServiceStatus>(
                                    valueListenable: status,
                                    builder: (BuildContext context,
                                        LocationServiceStatus value,
                                        Widget child) {
                                      switch (value) {
                                        case LocationServiceStatus.disabled:
                                        case LocationServiceStatus
                                            .permissionDenied:
                                        case LocationServiceStatus.unsubscribed:
                                          return const Icon(
                                            Icons.location_disabled,
                                            color: Colors.white,
                                          );
                                          break;
                                        case LocationServiceStatus.subscribed:
                                        default:
                                          return const Icon(
                                            Icons.location_searching,
                                            color: Colors.white,
                                          );
                                          break;
                                      }
                                    }),
                            onPressed: () => onPressed()),
                      ],
                    )),
              );
            },
          ),
          AttributionOptions(
              logoAssetName: 'assets/mapbox-logo.svg',
              // Use white for satellite layer it's better visible.
              color: mapboxStyle == MabboxTileset.satellite
                  ? Colors.white
                  : Colors.blueGrey,
              satelliteLayer: mapboxStyle == MabboxTileset.satellite),
        ]);
  }
}
