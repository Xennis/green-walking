import 'dart:developer' show log;
import 'dart:io' show Platform;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PuckLocation {
  PuckLocation({required this.position, this.bearing});

  Position position;
  double? bearing;
}

extension MapboxMapPosition on MapboxMap {
  Future<Position?> getCameraPosition() async {
    try {
      final CameraState mapCameraState = await getCameraState();
      return _positionForCoordinate(mapCameraState.center);
    } catch (e) {
      log('failed to get camera position: $e');
      return null;
    }
  }

  Future<PuckLocation?> getPuckLocation() async {
    try {
      final Layer? layer =
          Platform.isAndroid ? await style.getLayer('mapbox-location-indicator-layer') : await style.getLayer('puck');
      final LocationIndicatorLayer liLayer = layer as LocationIndicatorLayer;
      final List<double?>? location = liLayer.location;
      return Future.value(PuckLocation(position: Position(location![1]!, location[0]!), bearing: liLayer.bearing));
    } catch (e) {
      log('failed to get puck location: $e');
      return null;
    }
  }
}

Position _positionForCoordinate(Map<String?, Object?> raw) {
  final List<Object?> coordinates = raw['coordinates'] as List<Object?>;
  return Position(coordinates[0] as num, coordinates[1] as num);
}
