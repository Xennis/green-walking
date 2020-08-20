import 'dart:async';
import 'dart:developer';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:green_walking/services/places.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/types/marker.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:latlong/latlong.dart';

import '../core.dart';
import '../types/place.dart';
import '../widgets/map/attribution.dart';
import 'detail.dart';

class MapConfig {
  MapConfig({this.accessToken, this.lastLocation});

  String accessToken;
  LatLng lastLocation;

  static Future<MapConfig> create(
      AssetBundle assetBundle, LatLngBounds mapBounds) async {
    // FIXME: Move out here.
    await Firebase.initializeApp();

    final String accessToken =
        await assetBundle.loadString('assets/mapbox-access-token.txt');
    LatLng lastLocation =
        await SharedPrefs.getLatLng(SharedPrefs.KEY_LAST_LOCATION);
    if (lastLocation != null &&
        mapBounds != null &&
        !mapBounds.contains(lastLocation)) {
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
  final MapController mapController = MapController();
  final PopupController _popupController = PopupController();
  // (south-west, north-east)
  final LatLngBounds _mapBounds =
      LatLngBounds(LatLng(46.1037, 5.2381), LatLng(55.5286, 16.6275));
  List<PlaceMarker> places = <PlaceMarker>[];
  List<Marker> userLocationMarkers = <Marker>[];
  GeoHash _lastGeohash;

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
    //log("${hasGesture} lat ${_lastGeohash?.geohash} new ${_newGeohash.geohash}");
    _lastGeohash = _newGeohash;

    PlaceService.nearby(_newGeohash).then((List<Place> value) {
      setState(() {
        places = value
            .map((Place p) => PlaceMarker(
                  place: p,
                  anchorPos: AnchorPos.align(AnchorAlign.center),
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
    // You can use the userLocationOptions object to change the properties
    // of UserLocationOptions in runtime
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Walking'),
      ),
      drawer: NavigationDrawer(),
      body: FutureBuilder<MapConfig>(
          future: MapConfig.create(DefaultAssetBundle.of(context), _mapBounds),
          builder: (BuildContext context, AsyncSnapshot<MapConfig> snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Row(children: <Widget>[
                Flexible(
                  child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: (snapshot.data.lastLocation != null)
                            ? snapshot.data.lastLocation
                            : LatLng(53.5519, 9.8682),
                        zoom: 14.0,
                        plugins: <MapPlugin>[
                          AttributionPlugin(),
                          MarkerClusterPlugin(),
                          LocationPlugin(),
                        ],
                        minZoom: 12, // zoom out
                        maxZoom: 18, // zoom in
                        swPanBoundary: _mapBounds.southWest,
                        nePanBoundary: _mapBounds.northEast,
                        onTap: (_) => _popupController.hidePopup(),
                        onPositionChanged: onPositionChanged,
                      ),
                      layers: <LayerOptions>[
                        TileLayerOptions(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                          additionalOptions: <String, String>{
                            'accessToken': snapshot.data.accessToken,
                            'id': 'outdoors-v11',
                          },
                          // It is recommended to use TileProvider with a caching and retry strategy, like
                          // NetworkTileProvider or CachedNetworkTileProvider
                          tileProvider: const CachedNetworkTileProvider(),
                        ),
                        // Before MarkerClusterLayerOptions. Otherwise the user location is on top of markers
                        // and especially on top of pop-ups.
                        MarkerLayerOptions(markers: userLocationMarkers),
                        MarkerClusterLayerOptions(
                          size: const Size(40, 40),
                          markers: places,
                          builder:
                              (BuildContext context, List<Marker> markers) {
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
                              popupSnap: PopupSnap.top,
                              popupController: _popupController,
                              popupBuilder: (_, Marker marker) {
                                final Place p = (marker as PlaceMarker).place;
                                final TextStyle tx = TextStyle(
                                    color: Theme.of(context).accentColor);
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
                                            FlatButton(
                                              child: Text('OK', style: tx),
                                              onPressed: () =>
                                                  _popupController.hidePopup(),
                                            ),
                                            FlatButton(
                                              child: Text('DETAILS', style: tx),
                                              onPressed: () {
                                                if (p == null) {
                                                  log('no park found');
                                                  return;
                                                }
                                                Navigator.of(context).push<
                                                        dynamic>(
                                                    MaterialPageRoute<dynamic>(
                                                  builder:
                                                      (BuildContext context) =>
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
                              return;
                            }
                            SharedPrefs.setLatLng(
                                SharedPrefs.KEY_LAST_LOCATION, ld.location);
                          },
                          onLocationRequested: (LatLngData ld) {
                            final LatLng loca = ld?.location;
                            if (loca == null) {
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                  content: Text('Keine Position gefunden')));
                            } else if (!_mapBounds.contains(loca)) {
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                      'Position außerhalb von Deutschland')));
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
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FloatingActionButton(
                                          child: ValueListenableBuilder<
                                                  LocationServiceStatus>(
                                              valueListenable: status,
                                              builder: (BuildContext context,
                                                  LocationServiceStatus value,
                                                  Widget child) {
                                                switch (value) {
                                                  case LocationServiceStatus
                                                      .disabled:
                                                  case LocationServiceStatus
                                                      .permissionDenied:
                                                  case LocationServiceStatus
                                                      .unsubscribed:
                                                    return const Icon(
                                                      Icons.location_disabled,
                                                      color: Colors.white,
                                                    );
                                                    break;
                                                  case LocationServiceStatus
                                                      .subscribed:
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
                            logoAssetName: 'assets/mapbox-logo.svg'),
                      ]),
                )
              ]));
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
