import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../library/map_utils.dart';
import '../config.dart';
import '../widgets/download_map_dialog.dart';

class DownloadMapPage extends StatefulWidget {
  const DownloadMapPage({super.key, required this.tileStore});

  final TileStore tileStore;

  @override
  State<DownloadMapPage> createState() => _DownloadMapPageState();
}

class _DownloadMapPageState extends State<DownloadMapPage> {
  late MapboxMap _mapboxMap;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.downloadMapTitle),
      ),
      body: Center(
        child: Column(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: _isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(),
                        )
                      : const Icon(Icons.download),
                  onPressed: _isLoading ? null : _onDownloadPressed,
                  label: const Text("Download area"),
                ),
              ],
            ),
            Expanded(
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), child: _mapWidget()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapWidget() {
    return MapWidget(
        key: const ValueKey("downloadMapWidget"),
        styleUri: CustomMapboxStyles.outdoor,
        cameraOptions: CameraOptions(center: Point(coordinates: Position(9.8682, 53.5519)), zoom: 11.0),
        onMapCreated: (MapboxMap mapboxMap) {
          _mapboxMap = mapboxMap;
          // Disable
          _mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
          _mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
          _mapboxMap.gestures.updateSettings(GesturesSettings(rotateEnabled: false, pitchEnabled: false));
          // Bounds (minZoom: zoomed out towards globe)
          _mapboxMap.setBounds(CameraBoundsOptions(maxZoom: 14, minZoom: 10));
        });
  }

  Future<void> _onDownloadPressed() async {
    setState(() => _isLoading = true);
    final styleURI = await _mapboxMap.style.getStyleURI();
    final cameraBounds = await _mapboxMap.getCameraBounds();
    final regionLoadOptions = TileRegionLoadOptions(
        geometry: _coordinateBoundsToPolygon(cameraBounds).toJson(),
        descriptorsOptions: [TilesetDescriptorOptions(styleURI: styleURI, minZoom: 0, maxZoom: 16)],
        acceptExpired: true,
        networkRestriction: NetworkRestriction.DISALLOW_EXPENSIVE);
    // FIXME: Catch errors here?
    // FIXME: Esimate is somehow notworking anymore;
    // final estimateRegion = await widget.tileStore.estimateTileRegion("", regionLoadOptions, null, null).timeout(const Duration(seconds: 2));

    if (!mounted) return;
    final shouldDownload =
        await showDialog<bool>(context: context, builder: (context) => const DownloadMapDialog(estimateRegion: null));
    setState(() => _isLoading = false);
    if (shouldDownload != null && shouldDownload) {
      if (!mounted) return;
      Navigator.of(context).pop(regionLoadOptions);
    }
  }
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
