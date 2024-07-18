import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turf/turf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../library/util.dart';
import '../services/geocoding.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.place, required this.userPosition, required this.onTap});

  final GeocodingPlace place;
  final Position? userPosition;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final String subtitle = truncateString(place.placeName?.replaceFirst('${place.text ?? ''}, ', ''), 65) ?? '';

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: onTap,
        title: Text(truncateString(place.text, 25) ?? ''),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(subtitle),
          const Padding(padding: EdgeInsets.only(bottom: 8.0)),
          _FooterRow(
            userPosition: userPosition,
            place: place,
          )
        ]),
        trailing: _TrailingWidget(place: place),
      ),
    );
  }
}

class _TrailingWidget extends StatelessWidget {
  const _TrailingWidget({required this.place});

  final GeocodingPlace place;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    final List<Widget> children = [
      IconButton(
          color: theme.colorScheme.primary,
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
              color: Colors.green,
              tooltip: locale.openLocationDetailsSemanticLabel,
              icon: Icon(Icons.info_outline, semanticLabel: locale.openLocationDetailsSemanticLabel),
              onPressed: () => launchUrl(url)));
    }
    return Wrap(spacing: 1.0, children: children);
  }
}

class _FooterRow extends StatelessWidget {
  const _FooterRow({required this.place, required this.userPosition});

  final GeocodingPlace place;
  final Position? userPosition;

  @override
  Widget build(BuildContext context) {
    final Position? userPositionCopy = userPosition;
    final Position? placePosition = place.center;
    if (userPositionCopy == null || placePosition == null) {
      return Container();
    }

    final num distance = distanceRaw(placePosition, userPositionCopy, Unit.kilometers);
    String distanceString = '';
    if (distance >= 1) {
      distanceString = '${distance.toStringAsFixed(1)} km';
    } else {
      distanceString = '${(convertLength(distance, Unit.kilometers, Unit.meters)).toStringAsFixed(0)} m';
    }

    return Row(
      children: [
        const Icon(Icons.directions_run, size: 11.0),
        Text(distanceString, style: const TextStyle(fontSize: 11.0)),
      ],
    );
  }
}
