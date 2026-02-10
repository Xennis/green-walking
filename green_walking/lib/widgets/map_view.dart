import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../library/color_ex.dart';
import '../library/map_utils.dart';
import '../services/app_prefs.dart';
import '../widgets/app_bar.dart';
import '../widgets/location_button.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.lastCameraOption, required this.onOpenDrawer, required this.onSearchPage});

  final CameraOptions? lastCameraOption;
  final VoidCallback onOpenDrawer;
  final Future<Position?> Function({Position? userPosition, Position? reversePosition, Position? proximity})
      onSearchPage;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final ValueNotifier<UserLocationTracking> _userLocationTracking =
      ValueNotifier<UserLocationTracking>(UserLocationTracking.no);
  late MapboxMap _mapboxMap;

  CircleAnnotationManager? _circleAnnotationManager;
  Timer? _updateUserLocation;
  Timer? _hideScaleBar;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return Stack(
      children: <Widget>[
        _mapWidget(locale),
        SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                LocationButton(
                    trackUserLocation: _userLocationTracking,
                    onOkay: (bool permissionGranted) => _onLocationSearchPressed(locale, permissionGranted),
                    onNoPermissions: () => _displaySnackBar(locale.errorNoLocationPermission)),
                MapAppBar(
                  onLayerToogle: _onLayerToggle,
                  leading: IconButton(
                      icon: Icon(Icons.menu, semanticLabel: MaterialLocalizations.of(context).openAppDrawerTooltip),
                      onPressed: widget.onOpenDrawer),
                  title: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        hintText: locale.searchBoxHintLabel('...')),
                    onTap: () => _onSearchTap(),
                  ),
                )
              ],
            )),
      ],
    );
  }

  @override
  void dispose() {
    _updateUserLocation?.cancel();
    _hideScaleBar?.cancel();
    super.dispose();
  }

  Widget _mapWidget(AppLocalizations locale) {
    final mediaQueryData = MediaQuery.of(context);
    // A `SafeArea` is used for the app bar and location button but can not be
    // used here.
    final safeTop = mediaQueryData.viewPadding.top;
    final safeBottom = mediaQueryData.viewPadding.bottom;

    return MapWidget(
      key: const ValueKey('mapWidget'),
      onMapCreated: (MapboxMap mapboxMap) async {
        _mapboxMap = mapboxMap;
        unawaited(_mapboxMap.style.setProjection(StyleProjection(name: StyleProjectionName.globe)));
        // _mapboxMap.style.localizeLabels('en', null);
        //_mapboxMap.setTelemetryEnabled(false);
        unawaited(_mapboxMap.compass.updateSettings(CompassSettings(marginTop: safeTop + 78, marginRight: 13.0)));
        // By default the logo and attribution have little margin to the bottom
        unawaited(_mapboxMap.logo.updateSettings(LogoSettings(marginBottom: safeBottom + 13.0)));
        unawaited(_mapboxMap.attribution.updateSettings(AttributionSettings(marginBottom: safeBottom + 13.0)));
        // By default the scaleBar has a black primary colors which is pretty flashy.
        unawaited(_mapboxMap.scaleBar.updateSettings(ScaleBarSettings(
            enabled: false,
            position: OrnamentPosition.BOTTOM_LEFT,
            marginBottom: safeBottom + 48.0,
            marginLeft: 13.0,
            isMetricUnits: true,
            primaryColor: Colors.blueGrey.toInt32)));
        _circleAnnotationManager = await _mapboxMap.annotations.createCircleAnnotationManager();
      },
      cameraOptions:
          widget.lastCameraOption ?? CameraOptions(center: Point(coordinates: Position(9.8682, 53.5519)), zoom: 11.0),
      styleUri: CustomMapboxStyles.outdoor,
      onMapIdleListener: _onCameraIdle,
      onLongTapListener: _onLongTapListener,
      onCameraChangeListener: (CameraChangedEventData cameraChangedEventData) {
        unawaited(_mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: true)));
      },
      onScrollListener: (MapContentGestureContext context) {
        if (_userLocationTracking.value != UserLocationTracking.no) {
          // Turn off tracking because user scrolled to another location.
          _userLocationTracking.value = UserLocationTracking.no;
          _displaySnackBar(locale.followLocationOffToast);
        }
      },
    );
  }

  Future<void> _onLongTapListener(MapContentGestureContext context) async {
    try {
      final Position tapPosition = context.point.coordinates;
      final Position? userPosition = (await _mapboxMap.getPuckLocation())?.position;

      await _displaySearchResult(await widget.onSearchPage(userPosition: userPosition, reversePosition: tapPosition));
    } catch (e) {
      log('failed to get tap position: $e');
    }
  }

  Future<void> _onSearchTap() async {
    final Position? cameraPosition = await _mapboxMap.getCameraPosition();
    if (cameraPosition == null) {
      return;
    }
    final Position? userPosition = (await _mapboxMap.getPuckLocation())?.position;
    await _displaySearchResult(await widget.onSearchPage(userPosition: userPosition, proximity: cameraPosition));
  }

  void _onLayerToggle() async {
    final String currentStyle = await _mapboxMap.style.getStyleURI();
    if (currentStyle == CustomMapboxStyles.satellite) {
      unawaited(_mapboxMap.loadStyleURI(CustomMapboxStyles.outdoor));
    } else {
      unawaited(_mapboxMap.loadStyleURI(CustomMapboxStyles.satellite));
    }
  }

  Future<void> _onLocationSearchPressed(AppLocalizations locale, bool permissionGranted) async {
    if (_userLocationTracking.value == UserLocationTracking.position) {
      _userLocationTracking.value = UserLocationTracking.positionBearing;
    } else {
      // Display toast only once and not multiple times if button is pressed multiple times.
      if (_userLocationTracking.value == UserLocationTracking.no) {
        _displaySnackBar(locale.followLocationToast);
      }
      _userLocationTracking.value = UserLocationTracking.position;
    }
    await _mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true, pulsingEnabled: false, showAccuracyRing: true, puckBearingEnabled: true));
    await _refreshTrackLocation();
  }

  Future<void> _onCameraIdle(MapIdleEventData mapIdleEventData) async {
    // Delay hiding the scale bar.
    _hideScaleBar?.cancel();
    _hideScaleBar =
        Timer(const Duration(seconds: 1), () => _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false)));

    // TODO: Maybe use a Timer instead of writing data that often?
    final CameraState cameraState = await _mapboxMap.getCameraState();
    unawaited(AppPrefs.setCameraState(AppPrefs.keyLastPosition, cameraState));
  }

  Future<void> _setCameraPosition(Position position, double? bearing, double? pitch) async {
    await _mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position),
          bearing: bearing,
          pitch: pitch,
          zoom: 16.5,
        ),
        MapAnimationOptions(duration: 900 + 100));
  }

  Future<void> _refreshTrackLocation() async {
    _updateUserLocation?.cancel();
    unawaited(WakelockPlus.enable());
    _updateUserLocation = Timer.periodic(const Duration(milliseconds: 900), (timer) async {
      if (_userLocationTracking.value == UserLocationTracking.no) {
        unawaited(WakelockPlus.disable());
        _updateUserLocation?.cancel();
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

      switch (_userLocationTracking.value) {
        case UserLocationTracking.positionBearing:
          unawaited(_setCameraPosition(puckLocation.position, puckLocation.bearing, 50.0));
        case UserLocationTracking.position:
          unawaited(_setCameraPosition(puckLocation.position, 0.0, 0.0));
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
    _userLocationTracking.value = UserLocationTracking.no;
    unawaited(_setCameraPosition(position, 0, 0));

    // Draw circle
    await _circleAnnotationManager?.deleteAll();
    await _circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: Point(coordinates: position),
        circleRadius: 12,
        circleColor: const Color.fromRGBO(255, 192, 203, 1).toInt32,
        circleOpacity: 0.6,
        circleStrokeWidth: 2,
        circleStrokeColor: const Color.fromRGBO(255, 192, 203, 1).toInt32));
  }

  void _displaySnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        // Otherwise you can't click the custom floating button.
        dismissDirection: DismissDirection.none,
        duration: const Duration(seconds: 1, milliseconds: 200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 92.0, 22.0)));
  }
}
