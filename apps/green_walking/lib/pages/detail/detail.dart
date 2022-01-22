import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mapbox_gl/mapbox_gl.dart' show LatLng;
import 'package:url_launcher/url_launcher.dart';

import '../../core.dart';
import '../../types/place.dart';
import '../../widgets/place_list_tile.dart';
import 'footer.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.park, {Key? key}) : super(key: key);

  final Place park;

  // FIXME: Rework this and the functions below.
  Widget _location(String? location) {
    if (location == null) {
      return Container();
    }
    return Text(
      truncateString(location, 80) ?? '',
      style: const TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _DetailSpeedDial(park),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          Widget? fs;
          final String? imageUrl = park.image?.url;
          if (imageUrl != null) {
            fs = FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            );
          }
          return <Widget>[
            SliverAppBar(
              expandedHeight: imageUrl != null ? 200.0 : null,
              floating: false,
              pinned: false,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  semanticLabel:
                      MaterialLocalizations.of(context).backButtonTooltip,
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              flexibleSpace: fs,
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Name(name: park.name),
                  _location(park.location),
                  CategoryChips(
                    park.categories ?? <String>[],
                    truncateCutoff: 25,
                  ),
                  _Description(
                      extract: park.extract, description: park.description),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Padding(
                // Wide right padding because of floating action button.
                padding: const EdgeInsets.fromLTRB(15, 25, 85, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DetailFooter(
                      park.wikidataId,
                      image: park.image,
                      extract: park.extract,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DetailSpeedDial extends StatelessWidget {
  const _DetailSpeedDial(this.park, {Key? key}) : super(key: key);

  final Place park;

  @override
  Widget build(BuildContext context) {
    final List<SpeedDialChild> children = <SpeedDialChild>[];
    final LatLng? geopoint = park.geopoint;
    if (geopoint != null) {
      children.add(SpeedDialChild(
        onTap: () {
          String uri = 'geo:${geopoint.latitude},${geopoint.longitude}';
          if (park.name != null) {
            uri += '?q=${park.name}';
          }
          launch(uri);
        },
        label: AppLocalizations.of(context)!.maps,
        child: const Icon(Icons.map),
        backgroundColor: Colors.pinkAccent,
      ));
    }
    final String? wikipediaUrl = park.wikipediaUrl;
    if (wikipediaUrl != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(wikipediaUrl),
        label: 'Wikipedia',
        child: const Icon(Icons.book),
        backgroundColor: Colors.greenAccent,
      ));
    }
    final String? commonsUrl = park.commonsUrl;
    if (commonsUrl != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(commonsUrl),
        label: 'Commons',
        child: const Icon(Icons.photo),
        backgroundColor: Colors.orangeAccent,
      ));
    }
    final String? officalWebiste = park.officialWebsite;
    if (officalWebiste != null) {
      children.add(SpeedDialChild(
        onTap: () => launch(officalWebiste),
        label: AppLocalizations.of(context)!.website,
        child: const Icon(Icons.web),
        backgroundColor: Colors.blueAccent,
      ));
    }
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        children: children);
  }
}

class _Name extends StatelessWidget {
  const _Name({Key? key, this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    String text = AppLocalizations.of(context)!.nameless;
    if (name != null) {
      text = name!;
    }
    return Text(
      truncateString(text, 50) ?? '',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({Key? key, this.extract, this.description})
      : super(key: key);

  final PlaceExtract? extract;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;

    final List<InlineSpan> spans = <InlineSpan>[];
    String text;
    final String? extractText = extract?.text;
    if (extractText != null) {
      text = extractText;

      if (extract?.fallbackLang != null) {
        spans.add(TextSpan(
            text: '${locale.fallbackDescription}\n\n',
            style: const TextStyle(
                color: Colors.black, fontStyle: FontStyle.italic)));
      }
    } else if (description != null) {
      // Use Wikidata description as fallback.
      text = description!;
    } else {
      text = locale.missingDescription;
    }

    spans.add(TextSpan(
        text: text, style: const TextStyle(color: Colors.black, height: 1.5)));

    return RichText(textScaleFactor: 1.1, text: TextSpan(children: spans));
  }
}
