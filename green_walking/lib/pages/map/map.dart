import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    show ThemeReader;

import '../../services/mapbox_geocoding.dart';
import '../search.dart';
import 'mapbox_attribution.dart';
import 'fuu.dart';
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
  MapController mapController = MapController();
  MabboxTileset mapboxStyle = MabboxTileset.satellite;
  MapPosition? _lastMapPosition;
  LatLng? _lastLoc;

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();

    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
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
                                  mapController?.move(loc, 16.0);
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
                              mapController.move(value, 16.0);
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
    // TODO: Save last location
    /*
      onUserLocationUpdated: (UserLocation location) {
        SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, location.position);
      },
    */

    final List<Widget> layerOptions = [];
    if (mapboxStyle == MabboxTileset.outdoor) {
      // Mapbox source https://docs.mapbox.com/api/maps/vector-tiles/#example-request-retrieve-vector-tiles
      const String tilesetID = 'mapbox.mapbox-streets-v8';
      final String urlTemplate =
          'https://api.mapbox.com/v4/$tilesetID/{z}/{x}/{y}.mvt?style=${mapboxStyle.stylePath}@00&access_token=${config.accessToken}';
      final Map<String, dynamic> fuu =
          jsonDecode(fuuRaw) as Map<String, dynamic>;

      layerOptions.add(VectorTileLayerWidget(
          options: VectorTileLayerOptions(
              theme: ThemeReader().read(fuu),
              tileOffset: TileOffset.mapbox,
              tileProviders: TileProviders(
                  {'composite': _cachingTileProvider(urlTemplate)}))));
    } else {
      layerOptions.add(TileLayerWidget(
          options: TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: <String, String>{
          'accessToken': config.accessToken,
          'id': mapboxStyle.id ?? '',
        },
        tileProvider: NetworkTileProvider(),
        overrideTilesWhenUrlChanges: true,
      )));
    }
    layerOptions.add(
      LocationMarkerLayerWidget(
        plugin: LocationMarkerPlugin(
          centerCurrentLocationStream:
              _centerCurrentLocationStreamController.stream,
          centerOnLocationUpdate: _centerOnLocationUpdate,
        ),
      ),
    );

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          center: _lastMapPosition?.center ??
              config.lastLocation ??
              LatLng(53.5519, 9.8682),
          zoom: _lastMapPosition?.zoom ?? 11.0,
          interactiveFlags: InteractiveFlag.drag |
              InteractiveFlag.flingAnimation |
              InteractiveFlag.pinchMove |
              InteractiveFlag.pinchZoom |
              InteractiveFlag.doubleTapZoom,
          //InteractiveFlag.rotate,
          plugins: <MapPlugin>[VectorMapTilesPlugin()],
          onPositionChanged: (MapPosition position, bool hasGesture) {
            _lastMapPosition = position;
            if (hasGesture) {
              setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.never,
              );
            }
          }),
      children: layerOptions,
      nonRotatedChildren: <Widget>[
        MapboxAttribution(
            logoAssetName: 'assets/mapbox-logo.svg',
            // Use white for satellite layer it's better visible.
            color: mapboxStyle == MabboxTileset.satellite
                ? Colors.white
                : Colors.blueGrey,
            satelliteLayer: mapboxStyle == MabboxTileset.satellite),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              // Automatically center the location marker on the map when location updated until user interact with the map.
              setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
              );
              // Center the location marker on the map and zoom the map to level 18.
              _centerCurrentLocationStreamController.add(18);
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  VectorTileProvider _cachingTileProvider(String urlTemplate) {
    return MemoryCacheVectorTileProvider(
        delegate: NetworkVectorTileProvider(
            urlTemplate: urlTemplate,
            // this is the maximum zoom of the provider, not the
            // maximum of the map. vector tiles are rendered
            // to larger sizes to support higher zoom levels
            maximumZoom: 22),
        maxSizeBytes: 1024 * 1024 * 2);
  }
}
