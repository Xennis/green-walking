import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'download_map.dart';

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
    final offlineManager = await OfflineManager.create();
    final tmpDir = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(tmpDir.uri);

    final stylePacks = await offlineManager.allStylePacks();
    final regions = await tileStore.allTileRegions();

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
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _onDownloadNewMap,
                      child: Text(locale.downloadNewOfflineMapButton),
                    ),
                  ],
                ),
                const Divider(),
                _downloadProgressWidget(),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    //final expire = DateTime.fromMillisecondsSinceEpoch(pack.expires!)
                    return Card(
                      child: ListTile(
                        title: Text('Map: ${region.id}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _onDeleteRegion(region.id, index),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _stylePacks.length,
                  itemBuilder: (context, index) {
                    final pack = _stylePacks[index];
                    //final name = pack.styleURI == CustomMapboxStyles.outdoor ? "outdoor" : "satellite";
                    //final expire = DateTime.fromMillisecondsSinceEpoch(pack.expires!)
                    return Card(
                      child: ListTile(
                        title: const Text("Map Style: Outdoor"),
                        subtitle: const Text("Style (e.g. fonts, icons) of the map."),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: _regions.isEmpty ? () => _onDeleteStylePack(pack.styleURI, index) : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget _downloadProgressWidget() {
    final progress = _downloadProgress;
    if (progress == null) {
      return Container();
    }
    return StreamBuilder(
        stream: progress.stream,
        initialData: 0.0,
        builder: (context, snapshot) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Progress: ${(snapshot.requireData * 100).toStringAsFixed(0)}%"),
            LinearProgressIndicator(
              value: snapshot.requireData,
            )
          ]);
        });
  }

  Future<void> _onDownloadNewMap() async {
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
    try {
      await _downloadStylePack(styleURI);
      // Get all style packs because we most likely downloaded the same again.
      final stylePacks = await _offlineManager.allStylePacks();
      //setState(() {
      //          _stylePacks = stylePacks;
      //});
      final tileRegion = await _downloadTileRegion(
          regionId: DateTime.now().millisecondsSinceEpoch.toString(), regionLoadOptions: regionLoadOptions);
      setState(() {
        _stylePacks = stylePacks;
        _regions = [..._regions, tileRegion];
        _downloadProgress = null;
      });
    } catch (e) {
      log('failed to download map: $e');
      _displaySnackBar("Failed to map");
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

  Future<void> _onDeleteStylePack(String styleURI, int index) async {
    try {
      await _offlineManager.removeStylePack(styleURI);
      setState(() {
        _stylePacks.removeAt(index);
      });
      _displaySnackBar("Deleted map style");
    } catch (e) {
      log('failed to delete downloaded style pack: $e');
      _displaySnackBar("Failed to delete map style");
    }
  }

  Future<void> _onDeleteRegion(String regionId, int index) async {
    try {
      await _tileStore.removeRegion(regionId);
      setState(() {
        _regions.removeAt(index);
      });
      _displaySnackBar("Deleted map");
    } catch (e) {
      log('failed to remove downloaded region: $e');
      _displaySnackBar("Failed to delete map");
    }
  }

  void _displaySnackBar(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 1, milliseconds: 200)));
  }
}
