import 'dart:developer' show log;
import 'dart:io' show Platform;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PuckLocation {
  PuckLocation({required this.location, this.bearing});

  Position location;
  double? bearing;
}

extension PuckPosition on StyleManager {
  Future<PuckLocation?> getPuckLocation() async {
    try {
      final Layer? layer = Platform.isAndroid
          ? await getLayer('mapbox-location-indicator-layer')
          : await getLayer('puck');
      final LocationIndicatorLayer liLayer = layer as LocationIndicatorLayer;
      final List<double?>? location = liLayer.location;
      return Future.value(PuckLocation(
          location: Position(location![1]!, location[0]!),
          bearing: liLayer.bearing));
    } catch (e) {
      log('failed to get puck location: $e');
      return null;
    }
  }
}
