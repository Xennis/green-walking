import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../config.dart';
import '../library/offline.dart';
import '../widgets/offline/download_map_dialog.dart';

class DownloadMapPage extends StatefulWidget {
  const DownloadMapPage({super.key, required this.tileStore});

  final TileStore tileStore;

  @override
  State<DownloadMapPage> createState() => _DownloadMapPageState();
}

class _DownloadMapPageState extends State<DownloadMapPage> {
  late MapboxMap _mapboxMap;

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
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _onDownloadPressed,
                  child: Text(locale.downloadMapButton),
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
        key: const ValueKey('downloadMapWidget'),
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
    final regionLoadOptions = await createRegionLoadOptions(_mapboxMap);

    if (!mounted) return;
    final shouldDownload = await showDialog<bool>(
        context: context,
        builder: (context) => DownloadMapDialog(tileStore: widget.tileStore, regionLoadOptions: regionLoadOptions));
    if (shouldDownload != null && shouldDownload) {
      if (!mounted) return;
      Navigator.of(context).pop(regionLoadOptions);
    }
  }
}
