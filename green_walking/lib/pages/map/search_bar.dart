import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(
      {Key? key,
      required this.scaffoldKey,
      this.onSearchSubmitted,
      this.onLayerToogle})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(String)? onSearchSubmitted;
  final VoidCallback? onLayerToogle;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return SafeArea(
        top: true,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 7, 15, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(Icons.menu,
                        semanticLabel: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      // Otherwise the keyboard always appears.
                      autofocus: false,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          hintText: locale.searchBoxHintLabel('...')),
                      onSubmitted: onSearchSubmitted,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(
                        Icons.layers,
                        semanticLabel: locale.mapSwitchLayerSemanticLabel,
                      ),
                      onPressed: onLayerToogle,
                    ),
                  ),
                ],
              ),
            )));
  }
}
