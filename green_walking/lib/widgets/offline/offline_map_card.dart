import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../library/offline.dart';

class OfflineMapCard extends StatelessWidget {
  const OfflineMapCard({super.key, required this.region, required this.tileStore, required this.onDelete});

  final TileRegion region;
  final TileStore tileStore;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        title: Text(locale.offlineMapCardTitle),
        subtitle: FutureBuilder(
          future: tileStore.tileRegionMetadata(region.id),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData && data != null) {
              final downloadTime = OfflineMapMetadata.parseMetadata(data);
              if (downloadTime != null) {
                return Text(locale.offlineMapCardDownloadTime(downloadTime.toString()));
              }
            }
            return Container();
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class OfflineMapStyleCard extends StatelessWidget {
  const OfflineMapStyleCard({super.key, required this.stylePack, required this.canBeDeleted, required this.onDelete});

  final StylePack stylePack;
  final bool canBeDeleted;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        title: Text(locale.offlineMapStyleCardTitle),
        subtitle: Text(locale.offlineMapStyleCardSubtitle),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: canBeDeleted ? onDelete : null,
        ),
      ),
    );
  }
}
