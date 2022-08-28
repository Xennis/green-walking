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
    final LatLng? lastLocation =
        await SharedPrefs.getLatLng(SharedPrefs.KEY_LAST_LOCATION);

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
  final ValueNotifier<LatLng?> _userLocation = ValueNotifier<LatLng?>(null);

  MapboxMapController? mapController;
  MabboxTileset mapboxStyle = MabboxTileset.outdoor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  void dispose() {
    //mapController?.onSymbolTapped.remove(_onSymbolTapped);
    final LatLng? mapPosition = mapController?.cameraPosition?.target;
    if (mapPosition != null) {
      SharedPrefs.setLatLng(SharedPrefs.KEY_LAST_LOCATION, mapPosition);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      // If the search in the search bar is clicked the keyboard appears. The keyboard
      // should be over the map and by that avoid resizing of the whole app / map.
      resizeToAvoidBottomInset: false,
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
                            userLocation: _userLocation,
                            onOkay: () => _onLocationSearchPressed(locale),
                            onNoPermissions: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          locale.errorNoLocationPermission)),
                                )),
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
      onCameraIdle: _onCameraIdle,
      onStyleLoadedCallback: () async {
        // TODO(Xennis): Use Icons.location_pin
        //final ByteData bytes = await rootBundle.load('assets/place-icon.png');
        //final Uint8List list = bytes.buffer.asUint8List();
        //mapController?.addImage('place-marker', list);
      },
    );
  }

  Future<void> _onSearchSubmitted(String query, String accessToken) async {
    final LatLng? userLoc = await mapController?.requestMyLocationLatLng();
    final LatLng? moveToLoc = await Navigator.push(
        context,
        MaterialPageRoute<LatLng>(
          builder: (BuildContext context) =>
              SearchPage(mapboxGeocodingGet(query, accessToken, userLoc)),
        ));
    if (moveToLoc == null) {
      return;
    }
    mapController?.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: moveToLoc, zoom: 16.0)));
    mapController?.clearCircles();
    mapController?.addCircle(CircleOptions(
        circleRadius: 12,
        circleColor: '#FFC0CB',
        circleOpacity: 0.6,
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFC0CB',
        geometry: moveToLoc));
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
      await mapController?.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 16.0)));
      // Request location and camera position.target can slightly differ.
      _userLocation.value = mapController?.cameraPosition?.target;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(locale.errorNoPositionFound)));
    }
  }

  void _onCameraIdle() {
    if (_userLocation.value != null) {
      if (mapController?.cameraPosition?.target != _userLocation.value) {
        _userLocation.value = null;
      }
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
