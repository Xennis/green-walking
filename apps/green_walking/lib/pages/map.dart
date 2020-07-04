import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:green_walking/services/parks.dart';
import 'package:green_walking/widgets/drawer.dart';
import 'package:green_walking/widgets/place_list_tile.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

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
  final MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  Future<String> accessToken;

  List<Marker> markers = [];
  List<Marker> userLocationMarkers = [];

  @override
  void initState() {
    super.initState();
    accessToken = DefaultAssetBundle.of(context)
        .loadString("assets/mapbox-access-token.txt");

    mapController.onReady.then((value) {
      ParkService.load(context).then((value) {
        List<Marker> l = [];
        value.forEach((p) {
          l.add(Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            height: 50,
            width: 50,
            point: p.coordinateLocation,
            builder: (_) => Icon(
              Icons.nature_people,
              color: Colors.blueGrey,
              size: 50,
            ),
          ));
        });
        setState(() {
          markers = l;
        });
      });
    });
  }

  UserLocationOptions _createUserLocationOptions(BuildContext context) {
    return UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: userLocationMarkers,
        showHeading: true,
        zoomToCurrentLocationOnLoad: false,
        updateMapLocationOnPositionChange: false,
        showMoveToCurrentLocationFloatingActionButton: true,
        fabBottom: 16,
        fabRight: 16,
        fabWidth: 55,
        fabHeight: 55,
        moveToCurrentLocationFloatingActionButton: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40.0),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]),
          child: Icon(
            Icons.location_searching,
            color: Colors.white,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // You can use the userLocationOptions object to change the properties
    // of UserLocationOptions in runtime
    userLocationOptions = _createUserLocationOptions(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Green Walking'),
      ),
      drawer: MainDrawer(),
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
                          tileProvider: CachedNetworkTileProvider(),
                        ),
                        MarkerLayerOptions(markers: userLocationMarkers),
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
                                                if (p == null) {
                                                  log("no park found");
                                                  return;
                                                }
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
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
                        userLocationOptions,
                        AttributionOptions(
                            logoAssetName: "assets/mapbox-logo.svg"),
                      ]),
                )
              ]));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
