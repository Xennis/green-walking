import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:green_walking/types/place.dart';
import 'package:latlong/latlong.dart';

class PlaceMarker extends Marker {
  PlaceMarker(
      {LatLng point,
      WidgetBuilder builder,
      double width = 30.0,
      double height = 30.0,
      AnchorPos<dynamic> anchorPos,
      @required this.place})
      : assert(place != null),
        super(
            point: point,
            builder: builder,
            width: width,
            height: height,
            anchorPos: anchorPos);

  final Place place;
}
