import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../library/util.dart';

class DownloadMapDialog extends StatelessWidget {
  const DownloadMapDialog({super.key, required this.tileStore, required this.regionLoadOptions});

  final TileStore tileStore;
  final TileRegionLoadOptions regionLoadOptions;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(locale.downloadMapDialogTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            FutureBuilder(
              future: _estimateTileRegion(),
              builder: (context, snapshot) {
                final TileRegionEstimateResult? data = snapshot.data;
                if (snapshot.hasData && data != null) {
                  return Text(locale.downloadMapDialogEstimateResult(
                      formatBytes(data.storageSize, 0), formatBytes(data.transferSize, 0)));
                }
                if (snapshot.hasError) {
                  // TODO: Translate
                  return Text('Failed to estimate amount of storage: ${snapshot.error}');
                }
                return Row(
                  children: [
                    Text(locale.downloadMapDialogEstimateLoading),
                    Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(locale.downloadMapDialogCancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text(locale.downloadMapDialogConfirm.toUpperCase()),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ],
    );
  }

  Future<TileRegionEstimateResult> _estimateTileRegion() {
    // Some unique ID.
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    return tileStore.estimateTileRegion(id, regionLoadOptions, null, null).timeout(const Duration(seconds: 8));
  }
}
