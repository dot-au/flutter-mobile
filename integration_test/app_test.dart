import 'package:dot_mobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uuid/uuid.dart';

final loginButtonFinder = find.text("Log In");
final registerButtonFinder = find.text("Register");

final emailInputFinder = find.byKey(Key("emailInput"));
final passwordInputFinder = find.byKey(Key("passwordInput"));

final signUpButtonFinder = find.text("SIGN UP");
final signInButtonFinder = find.text("SIGN IN");

final settingsScreenButton = find.byKey(ValueKey("settingsScreenButton"));

class AuthCreds {
  final String email;
  final String password;

  AuthCreds(this.email, this.password);

  static AuthCreds generate() {
    return AuthCreds('${Uuid().v1()}@example.com', "thisisapassword");
  }
}

extension WidgetTesterExtension on WidgetTester {
  Future enterAuthCreds(AuthCreds creds) async {
    await tap(emailInputFinder);
    await pumpAndSettle();
    await enterText(emailInputFinder, creds.email);
    await pumpAndSettle();

    await tap(passwordInputFinder);
    await pumpAndSettle();
    await enterText(passwordInputFinder, creds.password);
    await pumpAndSettle();
  }

  Future register(AuthCreds creds) async {
    await enterAuthCreds(creds);

    await tap(signUpButtonFinder);
    await pumpAndSettle();
    await pump(Duration(seconds: 5));
    await pump(Duration(seconds: 5));
    await pump(Duration(seconds: 5));
  }

  Future signIn(AuthCreds creds) async {
    await enterAuthCreds(creds);

    await tap(signInButtonFinder);
    await pumpAndSettle();
    await pump(Duration(seconds: 5));
    await pump(Duration(seconds: 5));
    await pump(Duration(seconds: 5));
  }

  Future startApp() async {
    app.main();
    await pumpAndSettle();
  }

  Future signOut() async {
    await tap(settingsScreenButton);
    await pumpAndSettle();
    await tap(find.text("Log Out"));
    await pumpAndSettle();
  }

  Future goToLoginPage() async {
    await tap(loginButtonFinder);
    await pumpAndSettle();
  }

  Future goToSignUpPage() async {
    await tap(registerButtonFinder);
    await pumpAndSettle();
  }

  Future finishAuthFlow() async {
    await startApp();

    await goToSignUpPage();

    final creds = AuthCreds.generate();
    await register(creds);
    await signIn(creds);
  }

  Future goToContactScreen() async {
    await tap(find.byKey(Key("contactScreenButton")));

    await pumpAndSettle();
  }

  Future goToAddContact() async {
    await tap(find.text("Add Contact"));
    await pumpAndSettle();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final username = '${Uuid().v1()}@example.com';
  final password = 'thisisapassword';

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

  testWidgets('Can add a contact', (tester) async {
    await tester.finishAuthFlow();

    await tester.goToContactScreen();

    await tester.signOut();
  });
}
