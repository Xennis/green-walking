import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar({super.key, required this.leading, required this.title, this.onLayerToogle});

  final IconButton leading;
  final TextField title;
  final VoidCallback? onLayerToogle;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return SafeArea(
        top: true,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 11, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Row(
                  children: <Widget>[
                    leading,
                    Expanded(
                      child: title,
                    ),
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(
                        Icons.layers,
                        semanticLabel: locale.mapSwitchLayerSemanticLabel,
                      ),
                      onPressed: onLayerToogle,
                    ),
                  ],
                ),
              ),
            )));
  }
}
