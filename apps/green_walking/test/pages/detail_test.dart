import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:green_walking/pages/detail.dart';
import 'package:green_walking/types/place.dart';

void main() {
  testWidgets('long artist does not overflow', (WidgetTester tester) async {
    final PlaceImage i = PlaceImage(
        artist: "Unknown author, not menioned anywhere",
        licenseShortName: "Public domain");
    final Place p = Place(wikidataId: "1234", image: i, categories: []);
    await tester.pumpWidget(MaterialApp(
        home: DetailPage(
      park: p,
    )));
  });
}