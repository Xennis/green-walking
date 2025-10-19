import 'package:flutter/material.dart';
import 'package:turf/turf.dart';

import '../services/geocoding.dart';
import '../widgets/app_bar.dart';
import '../widgets/search_result_card.dart';
import '../l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.userPosition, this.reversePosition, this.proximity});

  final Position? userPosition;
  final Position? reversePosition;
  final Position? proximity;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryFieldController = TextEditingController();

  Future<GeocodingResult>? _result;
  bool _allowAdvancedSearch = false;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
        // If the search in the search bar is clicked the keyboard appears. The keyboard
        // should be over the map and by that avoid resizing of the whole app / map.
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            top: true,
            bottom: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MapAppBar(
                    leading: IconButton(
                        icon:
                            Icon(Icons.arrow_back, semanticLabel: MaterialLocalizations.of(context).backButtonTooltip),
                        onPressed: () => Navigator.pop(context)),
                    title: TextField(
                      controller: _queryFieldController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          hintText: locale.searchBoxHintLabel('...')),
                      onSubmitted: _onSearchSubmitted,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _resultList(context)),
                ],
              ),
            )));
  }

  Future<void> _onSearchSubmitted(String query) async {
    _queryFieldController.text = query;
    final Position? queryPosition = _stringToPosition(query);
    setState(() {
      if (queryPosition != null) {
        _allowAdvancedSearch = true;
        _result = mapboxReverseGeocoding(queryPosition);
      } else {
        _allowAdvancedSearch = false;
        _result = mapboxForwardGeocoding(query, proximity: widget.proximity);
      }
    });
  }

  Widget _resultList(BuildContext context) {
    if (_result == null) {
      return Container();
    }
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

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
                    return SearchResultCard(
                      place: data.features[index],
                      userPosition: widget.userPosition,
                      onTap: () {
                        Navigator.pop(
                          context,
                          elem.center,
                        );
                      },
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
                            style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12.0)))
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

String _positionToString(Position position, {int fractionDigits = 6}) {
  return '${position.lat.toStringAsFixed(fractionDigits)},${position.lng.toStringAsFixed(fractionDigits)}';
}

Position? _stringToPosition(String position) {
  final List<String> parts = position.split(',');
  if (parts.length != 2) {
    return null;
  }
  try {
    // String format is: lat,lng
    return Position.named(lat: double.parse(parts[0]), lng: double.parse(parts[1]));
  } catch (e) {
    return null;
  }
}
