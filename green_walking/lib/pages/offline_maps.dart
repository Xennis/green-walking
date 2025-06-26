import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/offline/offline_map_card.dart';
import 'download_map.dart';
import '../l10n/app_localizations.dart';

class OfflineMapsPage extends StatefulWidget {
  const OfflineMapsPage({super.key});

  @override
  State<OfflineMapsPage> createState() => _OfflineMapsPageState();
}

class _OfflineMapsPageState extends State<OfflineMapsPage> {
  late OfflineManager _offlineManager;
  late TileStore _tileStore;

  List<StylePack> _stylePacks = [];
  List<TileRegion> _regions = [];
  StreamController<double>? _downloadProgress;

  @override
  void initState() {
    super.initState();
    _setAsyncState();
  }

  void _setAsyncState() async {
    final tmpDir = await getTemporaryDirectory();
    final (offlineManager, tileStore) = await (OfflineManager.create(), TileStore.createAt(tmpDir.uri)).wait;
    final (stylePacks, regions) = await (offlineManager.allStylePacks(), tileStore.allTileRegions()).wait;

    setState(() {
      _offlineManager = offlineManager;
      _stylePacks = stylePacks;
      _tileStore = tileStore;
      _regions = regions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.offlineMapsPage),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _onDownloadNewMap(locale),
                      child: Text(locale.downloadNewOfflineMapButton),
                    ),
                  ],
                ),
                const Divider(),
                _downloadProgressWidget(locale),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    return OfflineMapCard(
                      region: region,
                      tileStore: _tileStore,
                      onDelete: () => _onDeleteRegion(locale, region.id, index),
                    );
                  },
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _stylePacks.length,
                  itemBuilder: (context, index) {
                    final pack = _stylePacks[index];
                    return OfflineMapStyleCard(
                        stylePack: pack,
                        canBeDeleted: _regions.isEmpty,
                        onDelete: () => _onDeleteStylePack(locale, pack.styleURI, index));
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget _downloadProgressWidget(AppLocalizations locale) {
    final progress = _downloadProgress;
    if (progress == null) {
      return Container();
    }
    return StreamBuilder(
        stream: progress.stream,
        initialData: 0.0,
        builder: (context, snapshot) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Text(locale.offlineMapProgress((snapshot.requireData * 100).toStringAsFixed(0))),
            LinearProgressIndicator(
              value: snapshot.requireData,
            )
          ]);
        });
  }

  Future<void> _onDownloadNewMap(AppLocalizations locale) async {
    final regionLoadOptions = await Navigator.push<TileRegionLoadOptions>(
        context,
        MaterialPageRoute(
            builder: (context) => DownloadMapPage(
                  tileStore: _tileStore,
                )));
    if (regionLoadOptions == null) {
      return;
    }
    final styleURI = regionLoadOptions.descriptorsOptions?.first?.styleURI;
    if (styleURI == null) {
      return;
    }
    final regionId = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _downloadStylePack(styleURI);
      // Get all style packs because we most likely downloaded the same again.
      final stylePacks = await _offlineManager.allStylePacks();
      final tileRegion = await _downloadTileRegion(regionId: regionId, regionLoadOptions: regionLoadOptions);
      setState(() {
        _stylePacks = stylePacks;
        _regions = [..._regions, tileRegion];
        _downloadProgress = null;
      });
    } catch (e) {
      log('failed to download map: $e');
      _displaySnackBar(locale.offlineMapDownloadFailed);
      setState(() => _downloadProgress = null);
    }
  }

  Future<StylePack> _downloadStylePack(String styleURI) async {
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode: GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        // metadata: {"tag": "test"},
        acceptExpired: false);

    final downloadProgress = StreamController<double>.broadcast();
    setState(() => _downloadProgress = downloadProgress);
    final stylePack = await _offlineManager.loadStylePack(styleURI, stylePackLoadOptions, (progress) {
      final percentage = progress.completedResourceCount / progress.requiredResourceCount;
      if (!downloadProgress.isClosed) {
        downloadProgress.sink.add(percentage);
      }
    });
    downloadProgress.sink.add(1);
    downloadProgress.sink.close();
    return stylePack;
  }

  Future<TileRegion> _downloadTileRegion(
      {required String regionId, required TileRegionLoadOptions regionLoadOptions}) async {
    final downloadProgress = StreamController<double>.broadcast();
    setState(() => _downloadProgress = downloadProgress);
    final tileRegion = await _tileStore.loadTileRegion(regionId, regionLoadOptions, (progress) {
      final percentage = progress.completedResourceCount / progress.requiredResourceCount;
      if (!downloadProgress.isClosed) {
        downloadProgress.sink.add(percentage);
      }
    });
    downloadProgress.sink.add(1);
    downloadProgress.sink.close();
    return tileRegion;
  }

  Future<void> _onDeleteStylePack(AppLocalizations locale, String styleURI, int index) async {
    try {
      await _offlineManager.removeStylePack(styleURI);
      setState(() {
        _stylePacks.removeAt(index);
      });
      _displaySnackBar(locale.offlineMapDeleteStylePackSuccess);
    } catch (e) {
      log('failed to delete downloaded style pack: $e');
      _displaySnackBar(locale.offlineMapDeleteStylePackFailed);
    }
  }

  Future<void> _onDeleteRegion(AppLocalizations locale, String regionId, int index) async {
    try {
      await _tileStore.removeRegion(regionId);
      setState(() {
        _regions.removeAt(index);
      });
      _displaySnackBar(locale.offlineMapDeleteRegionSuccess);
    } catch (e) {
      log('failed to remove downloaded region: $e');
      _displaySnackBar(locale.offlineMapDeleteRegionFailed);
    }
  }

  void _displaySnackBar(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 1, milliseconds: 200)));
  }
}
