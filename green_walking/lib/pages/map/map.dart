import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_walking/pages/map/tileset.dart';
import 'package:green_walking/pages/search.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';
import 'package:green_walking/services/shared_prefs.dart';
import 'package:green_walking/widgets/gdpr_dialog.dart';
import 'package:green_walking/widgets/navigation_drawer.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    show ThemeReader;

import 'fuu.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
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

  Widget searchBar(BuildContext context, String accessToken) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
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
                  mapController.move(value, 16.0);
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
    // TODO: Save last location
    /*
      onUserLocationUpdated: (UserLocation location) {
        SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, location.position);
      },
    */

    final List<LayerOptions> layerOptions = [];
    if (mapboxStyle == MabboxTileset.outdoor) {
      // Mapbox source https://docs.mapbox.com/api/maps/vector-tiles/#example-request-retrieve-vector-tiles
      const String tilesetID = 'mapbox.mapbox-streets-v8';
      final String urlTemplate =
          'https://api.mapbox.com/v4/$tilesetID/{z}/{x}/{y}.mvt?style=${mapboxStyle.stylePath}@00&access_token=${config.accessToken}';
      final Map<String, dynamic> fuu = jsonDecode(fuuRaw) as Map<String, dynamic>;

      layerOptions.add(VectorTileLayerOptions(
          theme: ThemeReader().read(fuu),
          tileOffset: TileOffset.mapbox,
          tileProviders:
              TileProviders({'composite': _cachingTileProvider(urlTemplate)})));
    } else {
      layerOptions.add(TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: <String, String>{
          'accessToken': config.accessToken,
          'id': mapboxStyle.id ?? '',
        },
        tileProvider: NetworkTileProvider(),
        overrideTilesWhenUrlChanges: true,
      ));
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          center: _lastMapPosition?.center ?? config.lastLocation ?? LatLng(53.5519, 9.8682),
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
          }),
      layers: layerOptions,
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
