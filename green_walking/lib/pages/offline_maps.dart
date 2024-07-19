import 'dart:developer' show log;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../routes.dart';

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

  @override
  void initState() {
    super.initState();
    _setAsyncState();
  }

  void _setAsyncState() async {
    final offlineManager = await OfflineManager.create();
    final stylePacks = await offlineManager.allStylePacks();
    final tmpDir = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(tmpDir.uri);
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
                      onPressed: () => Navigator.of(context).pushNamed(Routes.downloadMap),
                      child: Text(locale.downloadNewOfflineMapButton),
                    ),
                  ],
                ),
                const Divider(),
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
