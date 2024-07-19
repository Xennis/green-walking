import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../library/util.dart';

class DownloadMapPage extends StatefulWidget {
  const DownloadMapPage({super.key});

  @override
  State<DownloadMapPage> createState() => _DownloadMapPageState();
}

class _DownloadMapPageState extends State<DownloadMapPage> {
  // Only the outdoor map can be downloaded
  static const STYLE_URI = CustomMapboxStyles.outdoor;

  final StreamController<double> _stylePackProgress = StreamController.broadcast();
  final StreamController<double> _tileRegionLoadProgress = StreamController.broadcast();
  late OfflineManager _offlineManager;
  late TileStore _tileStore;
  late MapboxMap _mapboxMap;
  TileRegionEstimateResult? _estimateResult;

  @override
  void initState() {
    super.initState();
    _setAsyncState();
  }

  void _setAsyncState() async {
    final offlineManager = await OfflineManager.create();
    final tmpDir = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(tmpDir.uri);
    setState(() {
      _offlineManager = offlineManager;
      _tileStore = tileStore;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.downloadMapTitle),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: MapWidget(
                      key: const ValueKey("downloadMapWidget"),
                      styleUri: CustomMapboxStyles.outdoor,
                      cameraOptions: CameraOptions(center: Point(coordinates: Position(9.8682, 53.5519)), zoom: 11.0),
                      //onCameraChangeListener: (cameraChangedEventData) {
                      //  setState(() {
                      //    _estimateResult = null;
                      //  });
                      //},
                      onMapCreated: (MapboxMap mapboxMap) {
                        _mapboxMap = mapboxMap;
                        _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
                        _mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
                        _mapboxMap.gestures.updateSettings(GesturesSettings(rotateEnabled: false, pitchEnabled: false));
                      })),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: _estimateTileRegion,
                  child: const Text("Estimate size"),
                ),
                ElevatedButton(
                  onPressed: _onDownload,
                  child: const Text("Download (WiFi only)"),
                ),
              ],
            ),
            Text(_estimateResult != null
                ? 'Storage: ${formatBytes(_estimateResult!.storageSize, 0)}, Network transfer: ${formatBytes(_estimateResult!.transferSize, 0)}'
                : ""),
            StreamBuilder(
                stream: _tileRegionLoadProgress.stream,
                initialData: 0.0,
                builder: (context, snapshot) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("Progress: ${(snapshot.requireData * 100).toStringAsFixed(0)}%"),
                    LinearProgressIndicator(
                      value: snapshot.requireData,
                    )
                  ]);
                }),
          ],
        ),
      ),
    );
  }

  Future<Polygon> _cameraBoundingBox() async {
    final cameraState = await _mapboxMap.getCameraState();
    final cameraBounds = await _mapboxMap.coordinateBoundsForCamera(
        CameraOptions(center: cameraState.center, zoom: cameraState.zoom, pitch: cameraState.pitch));

    return Polygon.fromPoints(points: [
      [
        cameraBounds.southwest,
        Point(
            coordinates: Position.named(
                lng: cameraBounds.southwest.coordinates.lng, lat: cameraBounds.northeast.coordinates.lat)),
        cameraBounds.northeast,
        Point(
            coordinates: Position.named(
                lng: cameraBounds.northeast.coordinates.lng, lat: cameraBounds.southwest.coordinates.lat)),
      ]
    ]);
  }

  Future<TileRegionLoadOptions> _regionLoadOptions() async {
    final bounds = await _cameraBoundingBox();
    return TileRegionLoadOptions(
        geometry: bounds.toJson(),
        descriptorsOptions: [TilesetDescriptorOptions(styleURI: STYLE_URI, minZoom: 0, maxZoom: 16)],
        acceptExpired: true,
        networkRestriction: NetworkRestriction.DISALLOW_EXPENSIVE);
  }

  Future<void> _estimateTileRegion() async {
    setState(() {
      _estimateResult = null;
    });
    final estimated = await _tileStore.estimateTileRegion("", await _regionLoadOptions(), null, null);
    setState(() {
      _estimateResult = estimated;
    });
  }

  Future<void> _onDownload() async {
    final cameraState = await _mapboxMap.getCameraState();
    final id =
        '${cameraState.center.coordinates.lat.toStringAsFixed(6)},${cameraState.center.coordinates.lng.toStringAsFixed(6)}';
    await _downloadStylePack();
    await _downloadTileRegion(regionId: id);
  }

  Future<void> _downloadStylePack() async {
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode: GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        // metadata: {"tag": "test"},
        acceptExpired: false);
    _offlineManager.loadStylePack(STYLE_URI, stylePackLoadOptions, (progress) {
      final percentage = progress.completedResourceCount / progress.requiredResourceCount;
      if (!_stylePackProgress.isClosed) {
        _stylePackProgress.sink.add(percentage);
      }
    }).then((value) {
      _stylePackProgress.sink.add(1);
      _stylePackProgress.sink.close();
    }).onError((error, _) {
      log('failed to download style pack: $error');
      _displaySnackBar("Failed to map style download");
    });
  }

  Future<void> _downloadTileRegion({required String regionId}) async {
    _tileStore.loadTileRegion(regionId, await _regionLoadOptions(), (progress) {
      final percentage = progress.completedResourceCount / progress.requiredResourceCount;
      if (!_tileRegionLoadProgress.isClosed) {
        _tileRegionLoadProgress.sink.add(percentage);
      }
    }).then((value) {
      _tileRegionLoadProgress.sink.add(1);
      _tileRegionLoadProgress.sink.close();
    }).onError((error, _) {
      log('failed to download tile region: $error');
      _displaySnackBar("Failed to download map");
    });
  }

  void _displaySnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        // Otherwise you can't click the custom floating button.
        // dismissDirection: DismissDirection.none,
        duration: const Duration(seconds: 1, milliseconds: 200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 92.0, 22.0)));
  }
}
