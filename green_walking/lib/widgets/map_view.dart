import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../library/map_utils.dart';
import '../pages/search.dart';
import '../services/shared_prefs.dart';
import '../widgets/app_bar.dart';
import '../widgets/gdpr_dialog.dart';
import '../widgets/page_route.dart';
import '../widgets/location_button.dart';
import '../config.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.accessToken, required this.lastCameraOption, required this.onOpenDrawer});

  final String accessToken;
  final CameraOptions? lastCameraOption;
  final Function()? onOpenDrawer;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final ValueNotifier<UserLocationTracking> _userlocationTracking =
      ValueNotifier<UserLocationTracking>(UserLocationTracking.no);
  late MapboxMap _mapboxMap;

  CircleAnnotationManager? _circleAnnotationManager;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Stack(
      children: <Widget>[
        _mapWidget(),
        /*Attribution(
                            satelliteLayer:
                                _mapboxStyle == MabboxTileset.satellite),*/
        LocationButton(
            trackUserLocation: _userlocationTracking,
            onOkay: (bool permissionGranted) => _onLocationSearchPressed(locale, permissionGranted),
            onNoPermissions: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(locale.errorNoLocationPermission)),
                )),
        MapAppBar(
          onLayerToogle: _onLayerToggle,
          leading: IconButton(
              splashColor: Colors.grey,
              icon: Icon(Icons.menu, semanticLabel: MaterialLocalizations.of(context).openAppDrawerTooltip),
              onPressed: widget.onOpenDrawer),
          title: TextField(
            readOnly: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: locale.searchBoxHintLabel('...')),
            onTap: () => _onSearchTap(widget.accessToken),
          ),
        ),
      ],
    );
  }

  Widget _mapWidget() {
    return MapWidget(
      key: const ValueKey('mapWidget'),
      resourceOptions: ResourceOptions(accessToken: widget.accessToken),
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
      cameraOptions: widget.lastCameraOption ??
          CameraOptions(center: Point(coordinates: Position(9.8682, 53.5519)).toJson(), zoom: 11.0),
      styleUri: CustomMapboxStyles.outdoor,
      onMapIdleListener: _onCameraIdle,
      onLongTapListener: (ScreenCoordinate coordinate) => _onLongTapListener(widget.accessToken, coordinate),
      onScrollListener: (ScreenCoordinate coordinate) {
        if (_userlocationTracking.value != UserLocationTracking.no) {
          // Turn off tracking because user scrolled to another location.
          _userlocationTracking.value = UserLocationTracking.no;
        }
      },
    );
  }

  Future<void> _onLongTapListener(String accesstoken, ScreenCoordinate coordinate) async {
    try {
      // https://github.com/mapbox/mapbox-maps-flutter/issues/81 It actual returns the position
      // and not the coordinates.
      final Position tapPosition = Position(coordinate.y, coordinate.x);
      final Position? userPosition = (await _mapboxMap.getPuckLocation())?.position;

      // See https://dart.dev/tools/linter-rules/use_build_context_synchronously
      if (context.mounted) {
        final Position? moveToLoc = await Navigator.push(
          context,
          NoTransitionPageRoute<Position>(
              builder: (BuildContext context) =>
                  SearchPage(userPosition: userPosition, reversePosition: tapPosition, accessToken: accesstoken)),
        );
        return _displaySearchResult(moveToLoc);
      }
    } catch (e) {
      log('failed to get tap position: $e');
      return;
    }
  }

  Future<void> _onSearchTap(String accessToken) async {
    final Position? cameraPosition = await _mapboxMap.getCameraPosition();
    if (cameraPosition == null) {
      return;
    }
    final Position? userPosition = (await _mapboxMap.getPuckLocation())?.position;

    // See https://dart.dev/tools/linter-rules/use_build_context_synchronously
    if (context.mounted) {
      final Position? moveToLoc = await Navigator.push(
        context,
        NoTransitionPageRoute<Position>(
            builder: (BuildContext context) =>
                SearchPage(userPosition: userPosition, proximity: cameraPosition, accessToken: accessToken)),
      );
      return _displaySearchResult(moveToLoc);
    }
  }

  void _onLayerToggle() async {
    String currentStyle = await _mapboxMap.style.getStyleURI();
    if (currentStyle == CustomMapboxStyles.satellite) {
      _mapboxMap.loadStyleURI(CustomMapboxStyles.outdoor);
    } else {
      _mapboxMap.loadStyleURI(CustomMapboxStyles.satellite);
    }
  }

  Future<void> _onLocationSearchPressed(AppLocalizations locale, bool permissionGranted) async {
    if (_userlocationTracking.value == UserLocationTracking.position) {
      _userlocationTracking.value = UserLocationTracking.positionBearing;
    } else {
      _userlocationTracking.value = UserLocationTracking.position;
    }
    await _mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true, pulsingEnabled: false, showAccuracyRing: true, puckBearingEnabled: true));
    _refreshTrackLocation();
  }

  Future<void> _onCameraIdle(MapIdleEventData mapIdleEventData) async {
    // TODO: Maybe use a Timer instead of writing data that often?
    final CameraState cameraState = await _mapboxMap.getCameraState();
    SharedPrefs.setCameraState(SharedPrefs.keyLastPosition, cameraState);
  }

  Future<void> _setCameraPosition(Position position, double? bearing, double? pitch) async {
    return _mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position).toJson(),
          bearing: bearing,
          pitch: pitch,
          zoom: 16.5,
        ),
        MapAnimationOptions(duration: 900 + 100));
  }

  void _refreshTrackLocation() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (timer) async {
      if (_userlocationTracking.value == UserLocationTracking.no) {
        _timer?.cancel();
        return;
      }

      final PuckLocation? puckLocation =
          await _mapboxMap.getPuckLocation().timeout(const Duration(milliseconds: 900 - 100));
      if (puckLocation == null) {
        // FIXME: Show toast if no location.
        //  ScaffoldMessenger.of(context)
        //      .showSnackBar(SnackBar(content: Text(locale.errorNoPositionFound)));
        return;
      }

      switch (_userlocationTracking.value) {
        case UserLocationTracking.positionBearing:
          _setCameraPosition(puckLocation.position, puckLocation.bearing, 50.0);
        case UserLocationTracking.position:
          _setCameraPosition(puckLocation.position, 0.0, 0.0);
        case UserLocationTracking.no:
        // Handled above already. In case there is no location returned we would not cancel
        // the timer otherwise.
      }
    });
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
}
