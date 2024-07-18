import 'dart:developer' show log;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class OfflineMapsPage extends StatefulWidget {
  const OfflineMapsPage({super.key});

  @override
  State<OfflineMapsPage> createState() => _OfflineMapsPageState();
}

class _OfflineMapsPageState extends State<OfflineMapsPage> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.offlineMapsPage),
      ),
      body: FutureBuilder<_OfflineMapsConfig>(
          future: _OfflineMapsConfig.create(DefaultAssetBundle.of(context)),
          builder: (BuildContext context, AsyncSnapshot<_OfflineMapsConfig> snapshot) {
            final _OfflineMapsConfig? data = snapshot.data;
            if (snapshot.hasData && data != null) {
              return const Center(
                child: Column(
                  children: <Widget>[
                    Flexible(child: Text("TODO")),
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

class _OfflineMapsConfig {
  _OfflineMapsConfig(this.accessToken);

  String accessToken;

  static Future<_OfflineMapsConfig> create(AssetBundle assetBundle) async {
    final String accessToken = await assetBundle.loadString('assets/mapbox-access-token.txt');
    return _OfflineMapsConfig(accessToken);
  }
}
