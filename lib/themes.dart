import 'package:flutter/material.dart';

class ColorThemes {
  static const primaryColor = const Color(0xFF232F34);
  static const white = Colors.white;
}

class ButtonThemes {
  static ButtonStyle outlinedButtonThemeDark() {
    return OutlinedButton.styleFrom(
      backgroundColor: ColorThemes.primaryColor,
      primary: ColorThemes.white,
      shape: StadiumBorder(),
      side: BorderSide(width: 1, color: const Color(0xFF232F34)),
    );
  }

  static ButtonStyle outlinedButtonThemeLight() {
    return OutlinedButton.styleFrom(
      primary: ColorThemes.primaryColor,
      shape: StadiumBorder(),
      side: BorderSide(width: 1, color: const Color(0xFF232F34)),
    );
  }
}
