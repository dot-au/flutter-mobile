import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dot_mobile/main.dart';

void main() {
  testWidgets('home screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(DotApp(initialScreen: StarterPage()));

    expect(find.text("Log In"), findsOneWidget);
    expect(find.text("Register"), findsOneWidget);

  });
}