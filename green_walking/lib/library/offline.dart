import 'dart:developer' show log;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import './map_utils.dart';

class OfflineMapMetadata {
  static const String downloadTime = "download-time";

  static DateTime? parseMetadata(Map<String, Object> metadata) {
    try {
      final downloadTime = metadata[OfflineMapMetadata.downloadTime] as int;
      return DateTime.fromMillisecondsSinceEpoch(downloadTime);
    } catch (e) {
      log('failed to parse metadata: $e');
    }
    return null;
  }

  static Map<String, Object> createMetadata({required DateTime downloadTime}) {
    return {OfflineMapMetadata.downloadTime: downloadTime.millisecondsSinceEpoch};
  }
}

Future<TileRegionLoadOptions> createRegionLoadOptions(MapboxMap mapboxMap) async {
  final (String styleURI, CoordinateBounds cameraBounds, CameraBounds bounds) =
      await (mapboxMap.style.getStyleURI(), mapboxMap.getCameraBounds(), mapboxMap.getBounds()).wait;
  return TileRegionLoadOptions(
      geometry: _coordinateBoundsToPolygon(cameraBounds).toJson(),
      descriptorsOptions: [TilesetDescriptorOptions(styleURI: styleURI, minZoom: 6, maxZoom: bounds.maxZoom.floor())],
      acceptExpired: true,
      metadata: OfflineMapMetadata.createMetadata(downloadTime: DateTime.now()),
      networkRestriction: NetworkRestriction.DISALLOW_EXPENSIVE);
}

Polygon _coordinateBoundsToPolygon(CoordinateBounds bounds) {
  return Polygon.fromPoints(points: [
    [
      bounds.southwest,
      Point(coordinates: Position.named(lng: bounds.southwest.coordinates.lng, lat: bounds.northeast.coordinates.lat)),
      bounds.northeast,
      Point(coordinates: Position.named(lng: bounds.northeast.coordinates.lng, lat: bounds.southwest.coordinates.lat)),
    ]
  ]);
}
