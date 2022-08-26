import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../services/mapbox_geocoding.dart';
import '../../services/shared_prefs.dart';
import '../../widgets/gdpr_dialog.dart';
import '../../widgets/navigation_drawer.dart';
import '../search.dart';
import 'location_button.dart';
import 'search_bar.dart';
import 'tileset.dart';

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
                        LocationButton(
                            onOkay: () => _onLocationSearchPressed(locale),
                            onNoPermissions: () => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content: Text(
                                        locale.errorNoLocationPermission)))),
                        SearchBar(
                          scaffoldKey: _scaffoldKey,
                          onSearchSubmitted: (String query) =>
                              _onSearchSubmitted(query, data.accessToken),
                          onLayerToogle: _onLayerToggle,
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

  void _onSearchSubmitted(String query, String accessToken) {
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
  }

  void _onLayerToggle() {
    if (mapboxStyle == MabboxTileset.satellite) {
      setState(() {
        mapboxStyle = MabboxTileset.outdoor;
      });
    } else {
      setState(() {
        mapboxStyle = MabboxTileset.satellite;
      });
    }
  }

  Future<void> _onLocationSearchPressed(AppLocalizations locale) async {
    final LatLng? loc = await mapController?.requestMyLocationLatLng();
    if (loc != null) {
      mapController?.moveCamera(CameraUpdate.newLatLngZoom(loc, 16.0));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(locale.errorNoPositionFound)));
    }
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
}
