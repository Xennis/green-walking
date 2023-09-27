import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:green_walking/map_utils.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';
import '../../services/shared_prefs.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/gdpr_dialog.dart';
import '../../widgets/navigation_drawer.dart';
import '../../widgets/page_route.dart';
import '../search.dart';
import 'location_button.dart';
import 'mapbox_styles.dart';

class MapConfig {
  MapConfig(this.accessToken, {this.lastPosition});

  String accessToken;
  CameraOptions? lastPosition;

  static Future<MapConfig> create(AssetBundle assetBundle) async {
    final String accessToken =
        await assetBundle.loadString('assets/mapbox-access-token.txt');
    final CameraState? lastState =
        await SharedPrefs.getCameraState(SharedPrefs.keyLastPosition);
    if (lastState == null) {
      return MapConfig(accessToken, lastPosition: null);
    }
    final CameraOptions lastPosition = CameraOptions(
        center: lastState.center,
        zoom: lastState.zoom,
        bearing: lastState.bearing,
        pitch: lastState.pitch);
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
  final ValueNotifier<UserLocationTracking> _userlocationTracking =
      ValueNotifier<UserLocationTracking>(UserLocationTracking.no);

  late MapboxMap _mapboxMap;
  CircleAnnotationManager? _circleAnnotationManager;
  Timer? _timer;

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
      drawer: const AppNavigationDrawer(),
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
                        _mapWidget(context, data),
                        /*Attribution(
                            satelliteLayer:
                                _mapboxStyle == MabboxTileset.satellite),*/
                        LocationButton(
                            trackUserLocation: _userlocationTracking,
                            onOkay: (bool permissionGranted) =>
                                _onLocationSearchPressed(
                                    locale, permissionGranted),
                            onNoPermissions: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          locale.errorNoLocationPermission)),
                                )),
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

  Widget _mapWidget(BuildContext context, MapConfig config) {
    return MapWidget(
      key: const ValueKey('mapWidget'),
      resourceOptions: ResourceOptions(accessToken: config.accessToken),
      onMapCreated: (MapboxMap mapboxMap) {
        _mapboxMap = mapboxMap;

        //mapboxMap.setTelemetryEnabled(false);
        _mapboxMap.compass.updateSettings(CompassSettings(marginTop: 400.0));
        _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
        //mapController!.onSymbolTapped.add(_onSymbolTapped);
        //onPositionChanged(mapController!.cameraPosition);

        _mapboxMap.annotations.createCircleAnnotationManager().then((value) {
          _circleAnnotationManager = value;
        });
      },
      cameraOptions: config.lastPosition ??
          CameraOptions(
              center: Point(coordinates: Position(9.8682, 53.5519)).toJson(),
              zoom: 11.0),
      styleUri: CustomMapboxStyles.outdoor,
      onMapIdleListener: _onCameraIdle,
      onLongTapListener: (ScreenCoordinate coordinate) =>
          _onLongTapListener(context, config.accessToken, coordinate),
      onScrollListener: (ScreenCoordinate coordinate) {
        if (_userlocationTracking.value != UserLocationTracking.no) {
          // Turn off tracking because user scrolled to another location.
          _userlocationTracking.value = UserLocationTracking.no;
        }
      },
    );
  }

  Future<void> _onLongTapListener(BuildContext context, String accesstoken,
      ScreenCoordinate coordinate) async {
    try {
      // https://github.com/mapbox/mapbox-maps-flutter/issues/81 It actual returns the position
      // and not the coordinates.
      final Position tapPosition = Position(coordinate.y, coordinate.x);

      // See https://dart.dev/tools/linter-rules/use_build_context_synchronously
      if (context.mounted) {
        final Position? moveToLoc = await Navigator.push(
          context,
          NoTransitionPageRoute<Position>(
              builder: (BuildContext context) => SearchPage(
                  reversePosition: tapPosition, accessToken: accesstoken)),
        );
        return _displaySearchResult(moveToLoc);
      }
    } catch (e) {
      log('failed to get tap position: $e');
      return;
    }
  }

  Future<Position?> _getCameraPosition() async {
    try {
      final CameraState mapCameraState = await _mapboxMap.getCameraState();
      return positionForCoordinate(mapCameraState.center);
    } catch (e) {
      log('failed to get camera position: $e');
      return null;
    }
  }

  Future<void> _onSearchTab(String accessToken) async {
    final Position? cameraPosition = await _getCameraPosition();
    if (cameraPosition == null) {
      return;
    }
    // See https://dart.dev/tools/linter-rules/use_build_context_synchronously
    if (context.mounted) {
      final Position? moveToLoc = await Navigator.push(
        context,
        NoTransitionPageRoute<Position>(
            builder: (BuildContext context) => SearchPage(
                proximity: cameraPosition, accessToken: accessToken)),
      );
      return _displaySearchResult(moveToLoc);
    }
  }

  Future<void> _displaySearchResult(Position? position) async {
    if (position == null) {
      return;
    }
    // If we keep the tracking on the map would move back to the user location.
    _userlocationTracking.value = UserLocationTracking.no;
    _setCameraPosition(position, 0, 0);

    // Draw circle
    await _circleAnnotationManager?.deleteAll();
    _circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: Point(coordinates: position).toJson(),
        circleRadius: 12,
        circleColor: const Color.fromRGBO(255, 192, 203, 1).value,
        circleOpacity: 0.6,
        circleStrokeWidth: 2,
        circleStrokeColor: const Color.fromRGBO(255, 192, 203, 1).value));
  }

  void _onLayerToggle() async {
    String currentStyle = await _mapboxMap.style.getStyleURI();
    if (currentStyle == CustomMapboxStyles.satellite) {
      _mapboxMap.loadStyleURI(CustomMapboxStyles.outdoor);
    } else {
      _mapboxMap.loadStyleURI(CustomMapboxStyles.satellite);
    }
  }

  Future<void> _setCameraPosition(
      Position position, double? bearing, double? pitch) async {
    return _mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position).toJson(),
          bearing: bearing,
          pitch: pitch,
          zoom: 16.5,
        ),
        MapAnimationOptions(duration: 900 + 100));
  }

  void refreshTrackLocation() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (timer) async {
      if (_userlocationTracking.value == UserLocationTracking.no) {
        _timer?.cancel();
        return;
      }

      final PuckLocation? puckLocation = await _mapboxMap.style
          .getPuckLocation()
          .timeout(const Duration(milliseconds: 900 - 100));
      if (puckLocation == null) {
        // FIXME: Show toast if no location.
        //  ScaffoldMessenger.of(context)
        //      .showSnackBar(SnackBar(content: Text(locale.errorNoPositionFound)));
        return;
      }

      switch (_userlocationTracking.value) {
        case UserLocationTracking.positionBearing:
          _setCameraPosition(puckLocation.location, puckLocation.bearing, 50.0);
        case UserLocationTracking.position:
          _setCameraPosition(puckLocation.location, 0.0, 0.0);
        case UserLocationTracking.no:
        // Handled above already. In case there is no location returned we would not cancel
        // the timer otherwise.
      }
    });
  }

  Future<void> _onLocationSearchPressed(
      AppLocalizations locale, bool permissionGranted) async {
    if (_userlocationTracking.value == UserLocationTracking.position) {
      _userlocationTracking.value = UserLocationTracking.positionBearing;
    } else {
      _userlocationTracking.value = UserLocationTracking.position;
    }
    await _mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: false,
        showAccuracyRing: true,
        puckBearingEnabled: true));
    refreshTrackLocation();
  }

  Future<void> _onCameraIdle(MapIdleEventData mapIdleEventData) async {
    // TODO: Maybe use a Timer instead of writing data that often?
    final CameraState cameraState = await _mapboxMap.getCameraState();
    SharedPrefs.setCameraState(SharedPrefs.keyLastPosition, cameraState);
  }
}
