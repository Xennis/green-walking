import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension CameraStatePrefs on CameraState {
  Map<String, dynamic> toJson() {
    return {
      'center': center.toJson(),
      // 'padding': {
      //   'top': padding.top,
      //   'left': padding.left,
      //   'bottom': padding.bottom,
      //   'right': padding.right,
      // },
      'zoom': zoom,
      'bearing': bearing,
      'pitch': pitch,
    };
  }

  static CameraState fromJson(Map<String, dynamic> json) {
    return CameraState(
      center: Point.fromJson(json['center']),
      padding: MbxEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
      ),
      zoom: (json['zoom'] as num).toDouble(),
      bearing: (json['bearing'] as num).toDouble(),
      pitch: (json['pitch'] as num).toDouble(),
    );
  }
}
