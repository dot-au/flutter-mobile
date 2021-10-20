import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dot_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final loginButtonFinder = find.text("Log In");
  final registerButtonFinder = find.text("Register");

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

  // testWidgets(
  //   'Can register and sign in user',
  //   (WidgetTester tester) async {
  //     app.main();
  //     await tester.pumpAndSettle();
  //
  //     await tester.tap(registerButtonFinder);
  //     await tester.pumpAndSettle();
  //     await tester.pageBack();
  //     await tester.pumpAndSettle();
  //   },
  // );

  // testWidgets(, callback)

  // testWidgets("Something", (tester) async {});
}
