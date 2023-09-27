import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show Position;
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';
import '../services/geocoding.dart';
import '../widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(
      {Key? key,
      this.reversePosition,
      this.proximity,
      required this.accessToken})
      : super(key: key);

  final String accessToken;
  final Position? reversePosition;
  final Position? proximity;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<GeocodingResult>? _result;
  late TextEditingController _queryFieldController;

  @override
  void initState() {
    super.initState();
    _queryFieldController = TextEditingController();
    final initialQuery = widget.reversePosition;
    if (initialQuery != null) {
      _queryFieldController.text = _positionToString(initialQuery);
    }
  }

  @override
  void dispose() {
    _queryFieldController.dispose();
    super.dispose();
  }

  static String _positionToString(Position position, {int fractionDigits = 6}) {
    return '${position.lat.toStringAsFixed(fractionDigits)},${position.lng.toStringAsFixed(fractionDigits)}';
  }

  static Position? _stringToPosition(String position) {
    final List<String> parts = position.split(',');
    if (parts.length != 2) {
      return null;
    }
    try {
      // Yes, [1] comes first. We are showing the lat in the beginning.
      return Position(double.parse(parts[1]), double.parse(parts[0]));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
        // If the search in the search bar is clicked the keyboard appears. The keyboard
        // should be over the map and by that avoid resizing of the whole app / map.
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MapAppBar(
                leading: IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(Icons.arrow_back,
                        semanticLabel: MaterialLocalizations.of(context)
                            .backButtonTooltip),
                    onPressed: () => Navigator.pop(context)),
                title: TextField(
                  controller: _queryFieldController,
                  autofocus: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      hintText: locale.searchBoxHintLabel('...')),
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: _resultList(context),
              )),
            ],
          ),
        ));
  }

  Future<void> _onSearchSubmitted(String query) async {
    _queryFieldController.text = query;
    final Position? queryPosition = _stringToPosition(query);
    setState(() {
      if (queryPosition != null) {
        _result = mapboxReverseGeocoding(queryPosition, widget.accessToken);
        //_result = osmReverseGeocoding(queryPosition);
      } else {
        _result = mapboxForwardGeocoding(query, widget.accessToken,
            proximity: widget.proximity);
      }
    });
  }

  Widget _resultList(BuildContext context) {
    if (_result == null) {
      return Container();
    }
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return FutureBuilder<GeocodingResult>(
        future: _result,
        builder:
            (BuildContext context, AsyncSnapshot<GeocodingResult> snapshot) {
          final GeocodingResult? data = snapshot.data;
          if (snapshot.hasData && data != null) {
            if (data.features.isEmpty) {
              return Text(locale.searchNoResultsText);
            }
            return ListView.builder(
              itemCount: data.features.length,
              itemBuilder: (BuildContext context, int index) {
                final GeocodingPlace elem = data.features[index];
                final String subtitle = truncateString(
                        elem.placeName
                            ?.replaceFirst('${elem.text ?? ''}, ', ''),
                        65) ??
                    '';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.pop(
                        context,
                        elem.center,
                      );
                    },
                    title: Text(truncateString(elem.text, 25) ?? ''),
                    subtitle: Text(subtitle),
                    trailing: trailingWidget(locale, elem.url),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(locale.errorNoConnectionToSearchServer);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget? trailingWidget(AppLocalizations locale, Uri? url) {
    if (url == null) {
      return null;
    }
    return IconButton(
        splashColor: Colors.grey,
        icon: Icon(Icons.open_in_new,
            semanticLabel: locale.openInBrowserSemanticLabel),
        onPressed: () => launchUrl(url));
  }
}
