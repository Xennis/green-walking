import 'package:latlong/latlong.dart';

class Place {
  const Place(this.name, this.location);

  final String name;
  final LatLng location;

  factory Place.fromJson(Map<dynamic, dynamic> j) {
      LatLng location;
      var lat = j['location_lat'];
      var lng = j['location_lng'];
      if (lat != null && lng != null) {
        location = LatLng(lat.toDouble(), lng.toDouble());
      }
      return Place(j['name'], location);
  }
}