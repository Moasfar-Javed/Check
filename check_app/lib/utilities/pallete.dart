import 'package:flutter/material.dart';

class Palette {
  static const Color textColor = Color(0xFF878787); // lightGray
  static const Color text2Color = Color(0xFFF5F3F7); // veryLightGray
  
  static const MaterialColor appColorPalette = MaterialColor(
    0xff9a73b5, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
     <int, Color>{
      50:  Color(0xffa481bc), //10%
      100: Color(0xffae8fc4), //20%
      200: Color(0xffb89dcb), //30%
      300: Color(0xffc2abd3), //40%
      400: Color(0xffcdb9da), //50%
      500: Color(0xffd7c7e1), //60%
      600: Color(0xffe1d5e9), //70%
      700: Color(0xffebe3f0), //80%
      800: Color(0xfff5f1f8), //90%
      900: Color(0xffffffff), //100%
    },
  );
}
