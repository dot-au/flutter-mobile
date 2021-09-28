// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dot_mobile/screens/login_screen.dart';

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    
    Login page = Login(SignInForm());


    
    await tester.pumpWidget(Login());

    // verify text Log In
    expect(find.text('Log In'), findsOneWidget);

    // expect text box for email
    var textField1 = find.byType(TextField);
    expect(textField1, findsOneWidget);

    // expect text box for password
    var textField2 = find.byType(TextField);
    expect(textField2, findsOneWidget);

    // expect button
    var button = find.text("SIGN IN");
    expect(button, findsOneWidget);

  });
}
