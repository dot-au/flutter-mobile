import 'package:dot_mobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final username = '${Uuid().v1()}@example.com';
  final password = 'thisisapassword';

  final loginButtonFinder = find.text("Log In");
  final registerButtonFinder = find.text("Register");

  final emailInputFinder = find.byKey(Key("emailInput"));
  final passwordInputFinder = find.byKey(Key("passwordInput"));

  final signUpButtonFinder = find.text("SIGN UP");
  final signInButtonFinder = find.text("SIGN IN");

  final settingsScreenButton = find.byKey(ValueKey("settingsScreenButton"));

  testWidgets(
    'Starter page display correctly',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(tester.firstElement(loginButtonFinder), isNotNull);
      expect(tester.firstElement(registerButtonFinder), isNotNull);
    },
  );

  testWidgets(
    'Can navigate out of the starter page',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(registerButtonFinder);
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Can register user',
    (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.tap(registerButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(emailInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(emailInputFinder, '${Uuid().v1()}@example.com');
      await tester.pumpAndSettle();

      await tester.tap(passwordInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(passwordInputFinder, 'thisisapassword');
      await tester.pumpAndSettle();

      await tester.tap(signUpButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));

      tester.element(find.text("Log In"));
    },
  );

  testWidgets(
    'Can login and log out user',
    (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.tap(registerButtonFinder);
      await tester.pumpAndSettle();

      await tester.tap(emailInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(emailInputFinder, username);
      await tester.pumpAndSettle();

      await tester.tap(passwordInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(passwordInputFinder, password);
      await tester.pumpAndSettle();

      await tester.tap(signUpButtonFinder);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));

      await tester.tap(emailInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(emailInputFinder, username);
      await tester.pumpAndSettle();

      await tester.tap(passwordInputFinder);
      await tester.pumpAndSettle();
      await tester.enterText(passwordInputFinder, password);
      await tester.pumpAndSettle();

      await tester.tap(signInButtonFinder);
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));
      await tester.pump(Duration(seconds: 5));

      expect(tester.widget(find.text("Today's Meetings")), isNotNull);

      await tester.tap(settingsScreenButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Log Out"));
      await tester.pumpAndSettle();
    },
  );
}
