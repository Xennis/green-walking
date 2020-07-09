import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../types/place.dart';

class PlaceListTile extends StatelessWidget {
  final Place place;

  const PlaceListTile({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  String truncateString(String myString, int cutoff) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (place.location != null) {
      children.add(Row(
        children: [
          Text(truncateString(place.location, 35)),
        ],
      ));
    }
    children.add(CategoryChips(categories: place.categories));
    return ListTile(
      title: Text(place.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final int truncateCutoff;

  CategoryChips({@required this.categories, this.truncateCutoff = 15})
      : assert(categories != null);

  String truncateString(String myString, int cutoff) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  List<Widget> createCategoryCips(BuildContext context) {
    List<Widget> res = [];
    categories.forEach((c) {
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
    });
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
