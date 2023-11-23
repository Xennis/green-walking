import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show CameraOptions, CameraState, Position;

import 'search.dart';
import '../services/app_prefs.dart';
import '../widgets/user_consent_dialog.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => enableCrashReportingOrConsent(context));
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
                      onSearchPage: ({Position? userPosition, Position? reversePosition, Position? proximity}) {
                        return Navigator.push(
                          context,
                          _NoTransitionPageRoute<Position>(
                              builder: (BuildContext context) => SearchPage(
                                  userPosition: userPosition,
                                  reversePosition: reversePosition,
                                  proximity: proximity,
                                  accessToken: data.accessToken)),
                        );
                      },
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
    final CameraState? lastState = await AppPrefs.getCameraState(AppPrefs.keyLastPosition);
    if (lastState == null) {
      return _MapConfig(accessToken, lastPosition: null);
    }
    final CameraOptions lastPosition = CameraOptions(
        center: lastState.center, zoom: lastState.zoom, bearing: lastState.bearing, pitch: lastState.pitch);
    return _MapConfig(accessToken, lastPosition: lastPosition);
  }
}

class _NoTransitionPageRoute<T> extends MaterialPageRoute<T> {
  _NoTransitionPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
