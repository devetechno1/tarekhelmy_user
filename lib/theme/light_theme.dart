import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData light({
  Color primary = const Color(0xFF06d3cb),
  Color secondary = const Color(0xFF164745),
}) =>
    ThemeData(
      fontFamily: AppConstants.fontFamily,
      primaryColor: primary,
      secondaryHeaderColor: const Color(0xFF91FEFB),
      disabledColor: const Color(0xFFBABFC4),
      brightness: Brightness.light,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.03),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary)),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: const Color(0xFFFCFCFC),
        error: const Color(0xFFE84D4F),
      ),
      popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white, surfaceTintColor: Colors.white),
      dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
      bottomAppBarTheme: const BottomAppBarTheme(
        surfaceTintColor: Colors.white,
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 5),
      ),
      dividerTheme:
          const DividerThemeData(thickness: 0.2, color: Color(0xFFA0A4A8)),
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    );
