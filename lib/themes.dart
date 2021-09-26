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

  static ButtonStyle outlinedButtonThemeLight({
    Color color = ColorThemes.primaryColor,
  }) {
    return OutlinedButton.styleFrom(
      primary: color,
      shape: StadiumBorder(),
      side: BorderSide(width: 1, color: const Color(0xFF232F34)),
    );
  }

  static ButtonStyle textButtonThemeWithScaffoldBackground() {
    return TextButton.styleFrom(
      primary: Colors.white,
    );
  }

  static ButtonStyle elevatedButtonThemeLight({color: Colors.white}) {
    return ElevatedButton.styleFrom(
      primary: color, //change background color of button
      onPrimary: ColorThemes.primaryColor, //change text color of button
      shape: StadiumBorder(),
      side: BorderSide(width: 1, color: const Color(0xFF232F34)),
    );
  }
}
