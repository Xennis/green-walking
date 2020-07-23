import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

typedef UserLocationMarkerBuilder = Marker Function(
    BuildContext context, LatLng point);

typedef UserLocationButtonWidgetBuilder = Widget Function(
    BuildContext context, Future<LatLng> Function() requestLocation);

class UserLocationOptions extends LayerOptions {
  UserLocationOptions(
      {@required this.markers,
      @required this.onLocationUpdate,
      @required this.markerBuilder,
      @required this.buttonBuilder,
      this.updateIntervalMs = 1000 * 10})
      : assert(markers != null &&
            onLocationUpdate != null &&
            markerBuilder != null &&
            buttonBuilder != null),
        super();

  final Function(LatLng) onLocationUpdate;
  final UserLocationMarkerBuilder markerBuilder;
  final UserLocationButtonWidgetBuilder buttonBuilder;
  final int updateIntervalMs;
  List<Marker> markers;
}

class UserLocationLayer extends StatefulWidget {
  const UserLocationLayer({Key key, this.options, this.map, this.stream})
      : super(key: key);

  final UserLocationOptions options;
  final MapState map;
  final Stream<void> stream;

  @override
  _UserLocationLayerState createState() => _UserLocationLayerState();
}

class _UserLocationLayerState extends State<UserLocationLayer>
    with WidgetsBindingObserver {
  final Location _location = Location();
  StreamSubscription<LocationData> _onLocationChangedSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _location.changeSettings(interval: widget.options.updateIntervalMs);
  }

  @override
  void dispose() {
    _onLocationChangedSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _onLocationChangedSub?.cancel();
        break;
      case AppLifecycleState.resumed:
        //_onLocationChangedSub?.resume();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.options.buttonBuilder(context, () async {
      return _subscribeToLocationChanges();
    });
  }

  Future<LatLng> _subscribeToLocationChanges() async {
    if (!await _location.serviceEnabled()) {
      if (!await _location.requestService()) {
        return null;
      }
    }
    if (await _location.hasPermission() == PermissionStatus.denied) {
      if (await _location.requestPermission() != PermissionStatus.granted) {
        return null;
      }
    }
    _onLocationChangedSub =
        _location.onLocationChanged.listen((LocationData ld) {
      if (widget.options.markers.isNotEmpty) {
        widget.options.markers.removeLast();
      }
      final LatLng loc = _locationDataToLatLng(ld);
      if (loc == null) {
        return;
      }
      widget.options.markers.add(widget.options.markerBuilder(context, loc));
      widget.options.onLocationUpdate(loc);
    });

    return _locationDataToLatLng(await _location.getLocation());
  }
}

LatLng _locationDataToLatLng(LocationData ld) {
  if (ld.latitude == null || ld.longitude == null) {
    return null;
  }
  return LatLng(ld.latitude, ld.longitude);
}

class UserLocationPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is UserLocationOptions) {
      return UserLocationLayer(options: options, map: mapState, stream: stream);
    }
    throw Exception('Unknown options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is UserLocationOptions;
  }
}
