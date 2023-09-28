import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' show Position;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../core.dart';
import '../services/geocoding.dart';
import '../widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.reversePosition, this.proximity, required this.accessToken}) : super(key: key);

  final String accessToken;
  final Position? reversePosition;
  final Position? proximity;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<GeocodingResult>? _result;
  late TextEditingController _queryFieldController;
  bool _allowAdvancedSearch = false;

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
                    icon: Icon(Icons.arrow_back, semanticLabel: MaterialLocalizations.of(context).backButtonTooltip),
                    onPressed: () => Navigator.pop(context)),
                title: TextField(
                  controller: _queryFieldController,
                  autofocus: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      hintText: locale.searchBoxHintLabel('...')),
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: _resultList(context)),
            ],
          ),
        ));
  }

  Future<void> _onSearchSubmitted(String query) async {
    _queryFieldController.text = query;
    final Position? queryPosition = _stringToPosition(query);
    setState(() {
      if (queryPosition != null) {
        _allowAdvancedSearch = true;
        _result = mapboxReverseGeocoding(queryPosition, widget.accessToken);
      } else {
        _allowAdvancedSearch = false;
        _result = mapboxForwardGeocoding(query, widget.accessToken, proximity: widget.proximity);
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
        builder: (BuildContext context, AsyncSnapshot<GeocodingResult> snapshot) {
          final GeocodingResult? data = snapshot.data;
          if (snapshot.hasData && data != null) {
            if (data.features.isEmpty) {
              return Text(locale.searchNoResultsText);
            }
            return Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.features.length,
                  itemBuilder: (BuildContext context, int index) {
                    final GeocodingPlace elem = data.features[index];
                    final String subtitle =
                        truncateString(elem.placeName?.replaceFirst('${elem.text ?? ''}, ', ''), 65) ?? '';
                    return Card(
                      child: ListTile(
                        isThreeLine: true,
                        onTap: () {
                          Navigator.pop(
                            context,
                            elem.center,
                          );
                        },
                        title: Text(truncateString(elem.text, 25) ?? ''),
                        subtitle: Text(subtitle),
                        trailing: _trailingWidget(locale, elem),
                      ),
                    );
                  },
                ),
                _advancedSearchButton(locale, _allowAdvancedSearch),
                const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                const Divider(),
                Row(
                  children: [
                    Flexible(
                        child: Text(locale.geocodingResultLegalNotice(data.attribution),
                            style: const TextStyle(color: Colors.grey, fontSize: 12.0)))
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(locale.errorNoConnectionToSearchServer);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget? _trailingWidget(AppLocalizations locale, GeocodingPlace place) {
    final List<Widget> children = [
      IconButton(
          color: Theme.of(context).colorScheme.secondary,
          tooltip: locale.openLocationInDefaultAppSemanticLabel,
          icon: Icon(Icons.open_in_new, semanticLabel: locale.openLocationInDefaultAppSemanticLabel),
          onPressed: () => launchUrlString(
              'geo:${place.center!.lat.toStringAsFixed(6)},${place.center!.lng.toStringAsFixed(6)}?q=${Uri.encodeComponent(place.placeName!)}'))
    ];
    final Uri? url = place.url;
    if (url != null) {
      children.insert(
          0,
          IconButton(
              color: Theme.of(context).primaryColor,
              tooltip: locale.openLocationDetailsSemanticLabel,
              icon: Icon(Icons.info_outline, semanticLabel: locale.openLocationDetailsSemanticLabel),
              onPressed: () => launchUrl(url)));
    }
    return Wrap(spacing: 1.0, children: children);
  }

  Widget _advancedSearchButton(AppLocalizations locale, bool enable) {
    if (!enable) {
      return Container();
    }
    // Only for reverse geocoding we have an advanced search.
    final Position? queryPosition = _stringToPosition(_queryFieldController.text);
    if (queryPosition == null) {
      return Container();
    }

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 10.0)),
        TextButton(
          child: Text(locale.geocodingAdvancedSearchButton),
          onPressed: () {
            setState(() {
              _result = osmReverseGeocoding(queryPosition);
              _allowAdvancedSearch = false;
            });
          },
        ),
      ],
    );
  }
}
