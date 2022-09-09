import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../services/shared_prefs.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/gdpr_dialog.dart';
import '../../widgets/navigation_drawer.dart';
import '../../widgets/page_route.dart';
import '../search.dart';
import 'attribution.dart';
import 'location_button.dart';
import 'rotation_button.dart';
import 'tileset.dart';

class MapConfig {
  MapConfig(this.accessToken, {this.lastPosition});

  String accessToken;
  CameraPosition? lastPosition;

  static Future<MapConfig> create(AssetBundle assetBundle) async {
    final String accessToken =
        await assetBundle.loadString('assets/mapbox-access-token.txt');
    final CameraPosition? lastPosition =
        await SharedPrefs.getCameraPosition(SharedPrefs.keyLastPosition);

    return MapConfig(accessToken, lastPosition: lastPosition);
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<LatLng?> _userLocation = ValueNotifier<LatLng?>(null);
  final ValueNotifier<bool> _rotation = ValueNotifier(false);

  MapboxMapController? _mapController;
  MabboxTileset _mapboxStyle = MabboxTileset.outdoor;

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
      // If the search in the search bar is clicked the keyboard appears. The keyboard
      // should be over the map and by that avoid resizing of the whole app / map.
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawer(),
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
                        Attribution(
                            satelliteLayer:
                                _mapboxStyle == MabboxTileset.satellite),
                        LocationButton(
                            userLocation: _userLocation,
                            onOkay: (bool permissionGranted) =>
                                _onLocationSearchPressed(
                                    locale, permissionGranted),
                            onNoPermissions: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          locale.errorNoLocationPermission)),
                                )),
                        RotationButton(
                            rotation: _rotation,
                            onPressed: _onRotationButtonPressed),
                        MapAppBar(
                          onLayerToogle: _onLayerToggle,
                          leading: IconButton(
                              splashColor: Colors.grey,
                              icon: Icon(Icons.menu,
                                  semanticLabel:
                                      MaterialLocalizations.of(context)
                                          .openAppDrawerTooltip),
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openDrawer()),
                          title: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                hintText: locale.searchBoxHintLabel('...')),
                            onTap: () => _onSearchTab(data.accessToken),
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

  Widget map(BuildContext context, MapConfig config) {
    return MapboxMap(
      accessToken: config.accessToken,
      onMapCreated: (MapboxMapController controller) {
        controller.setTelemetryEnabled(false);
        _mapController = controller;
        //mapController!.onSymbolTapped.add(_onSymbolTapped);
        //onPositionChanged(mapController!.cameraPosition);
      },
      initialCameraPosition: config.lastPosition ??
          const CameraPosition(target: LatLng(53.5519, 9.8682), zoom: 11.0),
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      styleString: _mapboxStyle.id,
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

  Future<void> _onSearchTab(String accessToken) async {
    final LatLng? mapPosition = _mapController?.cameraPosition?.target;
    final LatLng? moveToLoc = await Navigator.push(
      context,
      NoTransitionPageRoute<LatLng>(
          builder: (BuildContext context) =>
              SearchPage(mapPosition: mapPosition, accessToken: accessToken)),
    );
    if (moveToLoc == null) {
      return;
    }
    _mapController?.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: moveToLoc, zoom: 16.0)));
    _mapController?.clearCircles();
    _mapController?.addCircle(CircleOptions(
        circleRadius: 12,
        circleColor: '#FFC0CB',
        circleOpacity: 0.6,
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFC0CB',
        geometry: moveToLoc));
  }

  void _onLayerToggle() {
    if (_mapboxStyle == MabboxTileset.satellite) {
      setState(() {
        _mapboxStyle = MabboxTileset.outdoor;
      });
    } else {
      setState(() {
        _mapboxStyle = MabboxTileset.satellite;
      });
    }
  }

  Future<void> _onLocationSearchPressed(
      AppLocalizations locale, bool permissionGranted) async {
    // mapbox-gl: `myLocationEnabled` is set to true above. Due to this the
    // library checks on initialization if it can enable it. But if the
    // permission are missing it can't. The result is that
    // `requestMyLocationLatLng` returns nothing (not even null).
    //
    // That's why in case of granted permission (i.e. the app had no permission
    // beforehand) we explicitly need to trigger `updateMyLocationEnabled`
    // which will be called by `updateMyLocationTrackingMode`.
    if (permissionGranted) {
      await _mapController
          ?.updateMyLocationTrackingMode(MyLocationTrackingMode.Tracking);
    }
    final LatLng? loc = await _mapController?.requestMyLocationLatLng();
    if (loc != null) {
      await _mapController?.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 16.0)));
      // Request location and camera position.target can slightly differ.
      _userLocation.value = _mapController?.cameraPosition?.target;
    } else {
      // See https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(locale.errorNoPositionFound)));
    }
  }

  void _onRotationButtonPressed() {
    final CameraPosition? position = _mapController?.cameraPosition;
    if (position != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: position.target,
              zoom: position.zoom,
              bearing: 0,
              tilt: 0)));
    }
  }

  void _onCameraIdle() {
    final CameraPosition? cameraPosition = _mapController?.cameraPosition;
    if (cameraPosition == null) {
      return;
    }

    if (_rotation.value &&
        cameraPosition.bearing == 0 &&
        cameraPosition.tilt == 0) {
      _rotation.value = false;
    } else if (!_rotation.value &&
        (cameraPosition.bearing != 0 || cameraPosition.tilt != 0)) {
      _rotation.value = true;
    }

    if (_userLocation.value != null) {
      if (cameraPosition.target != _userLocation.value) {
        _userLocation.value = null;
      }
    }

    SharedPrefs.setCameraPosition(SharedPrefs.keyLastPosition, cameraPosition);
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
