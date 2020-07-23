import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:green_walking/services/parks.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:green_walking/widgets/map/user_location.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:latlong/latlong.dart';

import '../types/place.dart';
import '../widgets/map/attribution.dart';
import 'detail.dart';

class MapConfig {
  MapConfig({this.accessToken, this.lastLocation, @required this.parks})
      : assert(parks != null);

  String accessToken;
  LatLng lastLocation;
  List<Marker> parks;
}

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  final PopupController _popupController = PopupController();
  List<Marker> userLocationMarkers = <Marker>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  Future<MapConfig> createMapConfig(BuildContext context) async {
    final String accessToken = await DefaultAssetBundle.of(context)
        .loadString('assets/mapbox-access-token.txt');
    final LatLng lastLocation =
        await SharedPrefs.getLatLng(SharedPrefs.KEY_LAST_LOCATION);

    final Iterable<Place> places = await ParkService.load(context);
    final List<Marker> parkMarkers = <Marker>[];
    for (final Place p in places) {
      parkMarkers.add(Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 50,
        width: 50,
        point: p.coordinateLocation,
        builder: (_) => const Icon(
          Icons.location_on,
          color: Colors.pink,
          size: 50,
        ),
      ));
    }

    return MapConfig(
        accessToken: accessToken,
        lastLocation: lastLocation,
        parks: parkMarkers);
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
          future: createMapConfig(context),
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
                        zoom: 15.0,
                        plugins: <MapPlugin>[
                          AttributionPlugin(),
                          MarkerClusterPlugin(),
                          UserLocationPlugin(),
                        ],
                        minZoom: 8, // zoom out
                        maxZoom: 18, // zoom in
                        swPanBoundary: LatLng(46.1037, 5.2381),
                        nePanBoundary: LatLng(55.5286, 16.6275),
                        onTap: (_) => _popupController.hidePopup(),
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
                        MarkerClusterLayerOptions(
                          size: const Size(40, 40),
                          markers: snapshot.data.parks,
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
                                final Place p = ParkService.get(marker.point);
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
                        MarkerLayerOptions(markers: userLocationMarkers),
                        UserLocationOptions(
                            markers: userLocationMarkers,
                            onLocationUpdate: (LatLng loc) {
                              mapController.move(loc, 15.0);
                              SharedPrefs.setLatLng(
                                  SharedPrefs.KEY_LAST_LOCATION, loc);
                            },
                            buttonBuilder: (BuildContext context,
                                Function requestLocation) {
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
                                            child: const Icon(
                                              Icons.location_searching,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => requestLocation()),
                                      ],
                                    )),
                              );
                            },
                            markerBuilder:
                                (BuildContext context, LatLng point) {
                              return Marker(
                                  height: 60.0,
                                  width: 60.0,
                                  point: point,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue[300]
                                                        .withOpacity(0.7)),
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blueAccent),
                                                height: 12.0,
                                                width: 12.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }),
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
