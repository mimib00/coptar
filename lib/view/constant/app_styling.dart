import 'package:copter/view/constant/colors.dart';
import 'package:flutter/material.dart';

class AppStyling {
  static final styling = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: kPrimaryColor,
    splashColor: kPrimaryColor.withOpacity(0.1),
    highlightColor: kPrimaryColor.withOpacity(0.1),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: kSecondaryColor.withOpacity(0.1),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kSecondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryColor,
      elevation: 0,
    ),
  );
}
