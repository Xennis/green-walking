import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/detail/detail.dart';
import 'package:green_walking/types/place.dart';

void main() {
  testWidgets('long artist does not overflow', (WidgetTester tester) async {
    final PlaceImage i = PlaceImage(
        artist: 'Unknown author, not menioned anywhere',
        licenseShortName: 'Public domain',
        descriptionUrl: '',
        url: '');
    final Place p = Place('1234', image: i, categories: <String>[]);
    await tester.pumpWidget(MaterialApp(
        home: DetailPage(
          p,
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate
        ]));
  });
}
