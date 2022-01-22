import 'package:flutter/material.dart';
import 'package:green_walking/services/mapbox_geocoding.dart';

import '../core.dart';
import '../intl.dart';

class SearchPage extends StatelessWidget {
  const SearchPage(this.result, {Key? key}) : super(key: key);

  final Future<MapboxGeocodingResult> result;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.searchResults),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _resultList(context),
          ],
        ),
      ),
    );
  }

  Widget _resultList(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context);
    return FutureBuilder<MapboxGeocodingResult>(
        future: result,
        builder: (BuildContext context,
            AsyncSnapshot<MapboxGeocodingResult> snapshot) {
          final MapboxGeocodingResult? data = snapshot.data;
          if (snapshot.hasData && data != null) {
            if (data.features.isEmpty) {
              return Text(locale.searchNoResultsText);
            }
            return Expanded(
                child: ListView.builder(
              itemCount: data.features.length,
              itemBuilder: (BuildContext context, int index) {
                final MaboxGeocodingPlace elem = data.features[index];
                final String subtitle = truncateString(
                        elem.placeName
                            ?.replaceFirst((elem.text ?? '') + ', ', ''),
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
            ));
          } else if (snapshot.hasError) {
            return Text(locale.errorNoConnectionToSearchServer);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
