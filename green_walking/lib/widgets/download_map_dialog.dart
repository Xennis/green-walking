import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show TileRegionEstimateResult;

import '../library/util.dart';

class DownloadMapDialog extends StatelessWidget {
  const DownloadMapDialog({super.key, required this.estimateRegion});

  final TileRegionEstimateResult? estimateRegion;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Download area?"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(_contentText()),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text("cancel".toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop(false);
            }),
        TextButton(
            child: Text("download".toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ],
    );
  }

  String _contentText() {
    final estimate = estimateRegion;
    if (estimate == null) {
      return 'No estimate';
    }
    return 'Estimation:\n${formatBytes(estimate.storageSize, 0)} storage\n${formatBytes(estimate.transferSize, 0)} network transfer';
  }
}
