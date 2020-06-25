import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../types/place.dart';

class PlaceListTile extends StatelessWidget {
  const PlaceListTile({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  final Place place;

  String truncateString(String myString, int cutoff) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  List<Widget> createCategoryCips() {
    List<Widget> res = [];
    place.categories.forEach((c) {
      res.add(Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: Icon(Icons.nature_people),
        ),
        label: Text(truncateString(c, 15)),
      ));
    });
    return res;
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
    children.add(Wrap(
      alignment: WrapAlignment.start,
      spacing: 5,
      children: createCategoryCips(),
    ));
    return ListTile(
      //leading: Icon(Icons.nature_people),
      title: Text(place.name),
      subtitle: Column(
        children: children,
      ),
    );
  }
}
