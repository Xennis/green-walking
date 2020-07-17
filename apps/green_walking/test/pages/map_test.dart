import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_walking/pages/map.dart';

void main() {
  testWidgets('MapPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapPage()));
  });
}
