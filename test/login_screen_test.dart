import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dot_mobile/screens/login_screen.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    
    await tester.pumpWidget(createWidgetForTesting(child: new Login()));

    // // verify text Log In
    // expect(find.text("Log In"), findsOneWidget);

    // // expect text box for email
    // expect(find.byType(TextField), findsOneWidget);

    // // expect text box for password
    // expect(find.byType(TextField), findsOneWidget);

    // expect button
    expect(find.text("SIGN IN"), findsOneWidget);

  });
}