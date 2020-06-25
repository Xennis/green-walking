import 'package:latlong/latlong.dart';

class Place {
  final String name;
  final List<String> aliases;
  final String description;
  final String location;
  final LatLng coordinates;
  final List<String> categories;
  final String wikiURL;

  const Place(this.name, this.aliases, this.description, this.location,
      this.coordinates, this.categories, this.wikiURL);

  factory Place.fromJson(Map<dynamic, dynamic> j) {
    // TODO: Add location.location
    String location = j['location']['administrative'];
    LatLng coordinates;
    var lat = j['coordinate location']['latitude'];
    var lng = j['coordinate location']['longitude'];
    if (lat != null && lng != null) {
      coordinates = LatLng(lat.toDouble(), lng.toDouble());
    }
    List<String> aliases = List<String>.from(j['aliases']);
    List<String> categories = List<String>.from(j['categories']);
    return Place(j['name'], aliases, j['description'], location, coordinates,
        categories, j['wiki_url']);
  }
}
