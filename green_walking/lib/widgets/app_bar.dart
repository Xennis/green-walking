import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar(
      {Key? key,
      this.scaffoldKey,
      this.onSearchSubmitted,
      this.onLayerToogle,
      this.onSearchTap})
      : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final void Function(String)? onSearchSubmitted;
  final GestureTapCallback? onSearchTap;
  final VoidCallback? onLayerToogle;

  Widget _leading(BuildContext context) {
    final GlobalKey<ScaffoldState>? key = scaffoldKey;
    if (key != null) {
      return IconButton(
          splashColor: Colors.grey,
          icon: Icon(Icons.menu,
              semanticLabel:
                  MaterialLocalizations.of(context).openAppDrawerTooltip),
          onPressed: () => key.currentState?.openDrawer());
    }

    return IconButton(
        splashColor: Colors.grey,
        icon: Icon(Icons.arrow_back,
            semanticLabel: MaterialLocalizations.of(context).backButtonTooltip),
        onPressed: () => Navigator.pop(context));
  }

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
                  _leading(context),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          hintText: locale.searchBoxHintLabel('...')),
                      onSubmitted: onSearchSubmitted,
                      readOnly: scaffoldKey != null,
                      onTap: onSearchTap,
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
