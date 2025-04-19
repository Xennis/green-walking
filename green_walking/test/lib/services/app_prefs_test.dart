import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/services/app_prefs.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('cameraState set and get', () async {
    // given
    SharedPreferences.setMockInitialValues({});
    Point center = Point(coordinates: Position(52.5200, 13.4050));
    CameraState cameraState = CameraState(
        center: center,
        padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        zoom: 10,
        bearing: 1.0,
        pitch: 2.0);

    // when
    bool actualSet = await AppPrefs.setCameraState('key', cameraState);
    CameraState? actualGet = await AppPrefs.getCameraState('key');

    // then
    expect(actualSet, true);
    expect(actualGet?.center, center);
    expect(actualGet?.zoom, 10);
    expect(actualGet?.bearing, 1.0);
    expect(actualGet?.pitch, 2.0);
  });
}
