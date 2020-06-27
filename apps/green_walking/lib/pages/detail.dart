import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/parks.dart';
import '../types/place.dart';

class DetailPageArguments {
  final LatLng coordinates;

  DetailPageArguments(this.coordinates);
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailPageArguments args = ModalRoute.of(context).settings.arguments;
    final Place park = ParkService.get(args.coordinates);
    List<Widget> children = [];
    if (park.description != null) {
      children.add(Text(park.description));
    }
    if (park.aliases.isNotEmpty) {
      children.add(Text("Aliases"));
      park.aliases.forEach((element) {
        children.add(Text(element));
      });
    }
    if (park.wikiURL != null) {
      children.add(RichText(
        text: TextSpan(
          text: 'Wikipedia',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(park.wikiURL);
            },
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(park.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Center(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
