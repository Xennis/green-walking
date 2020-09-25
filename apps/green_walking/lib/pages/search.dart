import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:green_walking/src/mapbox/geocoding.dart';

import '../core.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key, @required this.result})
      : assert(result != null),
        super(key: key);

  final Future<MapboxGeocodingResult> result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergebnisse'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _resultList(),
          ],
        ),
      ),
    );
  }

  Widget _resultList() {
    return FutureBuilder<MapboxGeocodingResult>(
        future: result,
        builder: (BuildContext context,
            AsyncSnapshot<MapboxGeocodingResult> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.features.isEmpty) {
              return const Text('Keine Treffer gefunden');
            }
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data.features.length,
              itemBuilder: (BuildContext context, int index) {
                final MaboxGeocordingPlace elem = snapshot.data.features[index];
                final String subtitle = truncateString(
                    elem.placeName.replaceFirst(elem.text + ', ', ''), 65);
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
                    title: Text(truncateString(elem.text, 25)),
                    subtitle: Text(subtitle),
                  ),
                );
              },
            ));
          } else if (snapshot.hasError) {
            return const Text('Keine Verbindung zum Suchserver');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
