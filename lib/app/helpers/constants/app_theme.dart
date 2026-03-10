import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _orange = Color(0xFFFF8C00);

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    canvasColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _orange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xffF5F5F0),
    cardColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF5F5F0),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
    ),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color.fromARGB(255, 120, 120, 120),
    colorScheme: ColorScheme.fromSeed(
      seedColor: _orange,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff121212),
    cardColor: const Color(0xff1E1E1E),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
    ),
    useMaterial3: true,
  );
}
