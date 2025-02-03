import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData dark({
  Color primary = const Color(0xFF068984),
  Color secondary = const Color(0xFF164745),
}) =>
    ThemeData(
      fontFamily: AppConstants.fontFamily,
      primaryColor: primary,
      secondaryHeaderColor: const Color(0xFF002F2D),
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: const Color(0xFF30313C),
      shadowColor: Colors.white.withOpacity(0.03),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary)),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: const Color(0xFF191A26),
        error: const Color(0xFFdd3135),
      ),
      popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
      dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
      bottomAppBarTheme: const BottomAppBarTheme(
        surfaceTintColor: Colors.black,
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 5),
      ),
      dividerTheme:
          const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    );
