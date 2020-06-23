import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

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
    minZoom: 6,
    maxZoom: 18,
    swPanBoundary: LatLng(46.1037, 5.2381),
    nePanBoundary: LatLng(55.5286, 16.6275),
  );
  Future<String> accessToken;

  @override
  void initState() {
    mapController = MapController();
    accessToken = DefaultAssetBundle.of(context).loadString("assets/mapbox-access-token.txt");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Green walking'),
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
                        ]),
                  )
                ]));
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
