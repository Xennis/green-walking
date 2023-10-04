import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show CameraOptions, CameraState;

import '../services/shared_prefs.dart';
import '../widgets/gdpr_dialog.dart';
import '../widgets/map_view.dart';
import '../widgets/navigation_drawer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => enableAnalyticsOrConsent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // If the search in the search bar is clicked the keyboard appears. The keyboard
      // should be over the map and by that avoid resizing of the whole app / map.
      resizeToAvoidBottomInset: false,
      drawer: const AppNavigationDrawer(),
      body: FutureBuilder<_MapConfig>(
          future: _MapConfig.create(DefaultAssetBundle.of(context)),
          builder: (BuildContext context, AsyncSnapshot<_MapConfig> snapshot) {
            final _MapConfig? data = snapshot.data;
            if (snapshot.hasData && data != null) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: MapView(
                      accessToken: data.accessToken,
                      lastCameraOption: data.lastPosition,
                      onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
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
}

class _MapConfig {
  _MapConfig(this.accessToken, {this.lastPosition});

  String accessToken;
  CameraOptions? lastPosition;

  static Future<_MapConfig> create(AssetBundle assetBundle) async {
    final String accessToken = await assetBundle.loadString('assets/mapbox-access-token.txt');
    final CameraState? lastState = await SharedPrefs.getCameraState(SharedPrefs.keyLastPosition);
    if (lastState == null) {
      return _MapConfig(accessToken, lastPosition: null);
    }
    final CameraOptions lastPosition = CameraOptions(
        center: lastState.center, zoom: lastState.zoom, bearing: lastState.bearing, pitch: lastState.pitch);
    return _MapConfig(accessToken, lastPosition: lastPosition);
  }
}
