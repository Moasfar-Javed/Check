import 'package:flutter/material.dart';

class Palette {
  static const Color textColorDarker = Color(0xFF4A4A4A);
  static const Color homeTodo = Color(0xFF4D4D4D);
  static const Color workTodo = Color(0xFF536771);
  static const Color studyTodo = Color(0xFF715467);
  static const Color redTodo = Color(0xFFD0312D);
  static const Color success = Color(0xFF33b17c);
  static const Color primaryColor = Color(0xFFcc3927);
  static const Color primaryColorVariant = Color(0xFFfb5a03);
  static const Color primaryColorShade = Color(0xFFfeefe5);
  static const Color accentColor = Color(0xFFfd6681);
  static const Color accentColorVariant = Color(0xFF8f002d);
  static const Color textColor = Color(0xFFf9efe6);
  static const Color textColorVariant = Color(0xFFdad0c8);
  static const Color backgroundColor = Color(0xFF210313);
  static const Color backgroundColorVariant = Color(0xFF2f1622);
  static const Color backgroundColorShade = Color(0xFF482c39);

  static final ThemeData appTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryColorVariant,
      secondary: accentColor,
      secondaryContainer: accentColorVariant,
      surface: backgroundColorVariant,
      background: backgroundColor,

      error: Colors.red, // Customize error color if needed
      onPrimary: textColor,
      onSecondary: textColor,
      onSurface: textColorVariant,
      onBackground: textColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundColorVariant,
      hintStyle: const TextStyle(color: textColorVariant),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: backgroundColorShade),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverElevation: 0,
      focusElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      // Use a gradient as the background color of the button
      // You can adjust the gradient colors or settings as needed
      // Here's an example using a linear gradient:
      // linearGradient: LinearGradient(
      //   colors: [Color(0xFFC43726), Color(0xFFFC9E3A)],
      // ),
    ),
  );
}
