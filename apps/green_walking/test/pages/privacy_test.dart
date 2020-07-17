import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:green_walking/pages/privacy.dart';

void main() {
  testWidgets('PrivacyPage() can be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PrivacyPage()));
  });
}
