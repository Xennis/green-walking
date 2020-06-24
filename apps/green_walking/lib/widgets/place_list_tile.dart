import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../types/place.dart';

class PlaceListTile extends StatelessWidget {
  const PlaceListTile({Key key, @required this.place}) : assert(place != null), super(key: key);

  final Place place;

  Widget build(BuildContext context) {
    return ListTile(
      //leading: Icon(Icons.nature_people),
      title: Text(place.name),
      subtitle: Column(
        children: [
          Row(
            children: [
              // FIXME: Replace dummy data.
              Text('Sternschanze, Altona'),
            ],
          ),
          Row(
            // FIXME: Replace dummy data.
            children: [
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.nature_people),
                ),
                label: Text('Park'),
              ),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.hotel),
                ),
                label: Text('Kulturerbe'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
