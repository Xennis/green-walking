import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../intl.dart';
import '../types/place.dart';

class PlaceListTile extends StatelessWidget {
  const PlaceListTile({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (place.location != null) {
      children.add(Row(
        children: <Widget>[
          Text(truncateString(place.location, 35)),
        ],
      ));
    }
    if (place.categories != null) {
      children.add(CategoryChips(categories: place.categories));
    }
    String name;
    if (place.name == null) {
      name = AppLocalizations.of(context).nameless;
    }
    return ListTile(
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips(
      {Key key, @required this.categories, this.truncateCutoff = 15})
      : assert(categories != null),
        super(key: key);

  final List<String> categories;
  final int truncateCutoff;

  List<Widget> createCategoryCips(BuildContext context) {
    final List<Widget> res = <Widget>[];
    for (final String c in categories) {
      res.add(Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(
            Icons.nature,
            color: Theme.of(context).primaryColor,
          ),
        ),
        label: Text(truncateString(c, truncateCutoff)),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: createCategoryCips(context),
    );
  }
}
