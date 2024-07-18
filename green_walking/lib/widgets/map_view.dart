import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../library/map_utils.dart';
import '../services/app_prefs.dart';
import '../widgets/app_bar.dart';
import '../widgets/location_button.dart';
import '../config.dart';

class MapView extends StatefulWidget {
  const MapView(
      {super.key,
      required this.accessToken,
      required this.lastCameraOption,
      required this.onOpenDrawer,
      required this.onSearchPage});

  final String accessToken;
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
            onTap: () => _onSearchTap(widget.accessToken),
          ),
        ),
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
    // TODO: Move it up in the stack, see: https://github.com/mapbox/mapbox-maps-flutter/blob/main/example/lib/main.dart#L120
    MapboxOptions.setAccessToken(widget.accessToken);
    return MapWidget(
      key: const ValueKey('mapWidget'),
      onMapCreated: (MapboxMap mapboxMap) {
        _mapboxMap = mapboxMap;
        _mapboxMap.style.setProjection(StyleProjection(name: StyleProjectionName.globe));
        // _mapboxMap.style.localizeLabels('en', null);
        //_mapboxMap.setTelemetryEnabled(false);
        _mapboxMap.compass.updateSettings(CompassSettings(marginTop: 125.0, marginRight: 13.0));
        // By default the logo and attribution have little margin to the bottom
        _mapboxMap.logo.updateSettings(LogoSettings(marginBottom: 13.0));
        _mapboxMap.attribution.updateSettings(AttributionSettings(marginBottom: 13.0));
        // By default the scaleBar has a black primary colors which is pretty flashy.
        _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(
            enabled: false,
            position: OrnamentPosition.BOTTOM_LEFT,
            marginBottom: 48.0,
            marginLeft: 13.0,
            isMetricUnits: true,
            primaryColor: Colors.blueGrey.value));
        _mapboxMap.annotations.createCircleAnnotationManager().then((value) {
          _circleAnnotationManager = value;
        });
      },
      cameraOptions:
          widget.lastCameraOption ?? CameraOptions(center: Point(coordinates: Position(9.8682, 53.5519)), zoom: 11.0),
      styleUri: CustomMapboxStyles.outdoor,
      onMapIdleListener: _onCameraIdle,
      onLongTapListener: _onLongTapListener,
      onCameraChangeListener: (CameraChangedEventData cameraChangedEventData) {
        _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: true));
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

      return _displaySearchResult(await widget.onSearchPage(userPosition: userPosition, reversePosition: tapPosition));
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
    return _displaySearchResult(await widget.onSearchPage(userPosition: userPosition, proximity: cameraPosition));
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
    _refreshTrackLocation();
  }

  Future<void> _onCameraIdle(MapIdleEventData mapIdleEventData) async {
    // Delay hiding the scale bar.
    _hideScaleBar?.cancel();
    _hideScaleBar =
        Timer(const Duration(seconds: 1), () => _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false)));

    // TODO: Maybe use a Timer instead of writing data that often?
    final CameraState cameraState = await _mapboxMap.getCameraState();
    AppPrefs.setCameraState(AppPrefs.keyLastPosition, cameraState);
  }

  Future<void> _setCameraPosition(Position position, double? bearing, double? pitch) async {
    return _mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position),
          bearing: bearing,
          pitch: pitch,
          zoom: 16.5,
        ),
        MapAnimationOptions(duration: 900 + 100));
  }

  void _refreshTrackLocation() async {
    _updateUserLocation?.cancel();
    WakelockPlus.enable();
    _updateUserLocation = Timer.periodic(const Duration(milliseconds: 900), (timer) async {
      if (_userLocationTracking.value == UserLocationTracking.no) {
        WakelockPlus.disable();
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
          _setCameraPosition(puckLocation.position, puckLocation.bearing, 50.0);
        case UserLocationTracking.position:
          _setCameraPosition(puckLocation.position, 0.0, 0.0);
        case UserLocationTracking.no:
        // Handled above already. In case there is no location returned we would not cancel
        // the timer otherwise.
      }
    });
  }

  void _displaySearchResult(Position? position) async {
    if (position == null) {
      return;
    }
    // If we keep the tracking on the map would move back to the user location.
    _userLocationTracking.value = UserLocationTracking.no;
    _setCameraPosition(position, 0, 0);

    // Draw circle
    await _circleAnnotationManager?.deleteAll();
    _circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: Point(coordinates: position),
        circleRadius: 12,
        circleColor: const Color.fromRGBO(255, 192, 203, 1).value,
        circleOpacity: 0.6,
        circleStrokeWidth: 2,
        circleStrokeColor: const Color.fromRGBO(255, 192, 203, 1).value));
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
