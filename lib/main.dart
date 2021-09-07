import 'dart:math';

import 'package:dot_mobile/screens/login_screen.dart';
import 'package:dot_mobile/screens/register_screen.dart';
import 'package:dot_mobile/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var initialScreen;
  if (FirebaseAuth.instance.currentUser == null) {
    initialScreen = StarterPage();
  } else {
    initialScreen = HomeScreen();
  }

  runApp(DotApp(
    initialScreen: initialScreen,
  ));
}

class DotApp extends StatelessWidget {
  final Widget initialScreen;

  const DotApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DOT',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorThemes.primaryColor,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonThemes.outlinedButtonThemeLight(),
        ),
      ),
      home: initialScreen,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Something"),
        ],
      ),
    );
  }
}

class StarterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/logo-white.png',
              width: 200,
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                onPressed: () async {
                  await Get.to(() => Login());
                },
                child: Text("Log In"),
              ),
              _buildButton(
                onPressed: () async {
                  await Get.to(() => RegisterScreen());
                },
                child: Text("Register"),
                style: ButtonThemes.outlinedButtonThemeDark(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required Widget child,
    ButtonStyle? style,
    required VoidCallback onPressed,
  }) {
    final bottomSafeArea = MediaQuery.of(Get.context!).padding.bottom;
    final paddingBottom = max<double>(
      0,
      16 - bottomSafeArea,
    );

    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          12,
          16,
          12,
          paddingBottom,
        ),
        height: 64,
        child: OutlinedButton(
          onPressed: onPressed,
          child: child,
          style: style,
        ),
      ),
    );
  }
}
