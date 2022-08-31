import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../core.dart';
import '../services/mapbox_geocoding.dart';
import '../widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.mapPosition, required this.accessToken})
      : super(key: key);

  final String accessToken;
  final LatLng? mapPosition;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<MapboxGeocodingResult>? _result;

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
    setState(() {
      _result =
          mapboxGeocodingGet(query, widget.accessToken, widget.mapPosition);
    });
  }

  Widget _resultList(BuildContext context) {
    if (_result == null) {
      return Container();
    }
    final AppLocalizations locale = AppLocalizations.of(context)!;
    return FutureBuilder<MapboxGeocodingResult>(
        future: _result,
        builder: (BuildContext context,
            AsyncSnapshot<MapboxGeocodingResult> snapshot) {
          final MapboxGeocodingResult? data = snapshot.data;
          if (snapshot.hasData && data != null) {
            if (data.features.isEmpty) {
              return Text(locale.searchNoResultsText);
            }
            return ListView.builder(
              itemCount: data.features.length,
              itemBuilder: (BuildContext context, int index) {
                final MaboxGeocodingPlace elem = data.features[index];
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
}
