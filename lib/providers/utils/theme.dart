import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: Colors.deepPurple,
      secondary: Colors.purpleAccent,
      background: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // 🔲 Cards (nuevo API Flutter 3.35+)
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      labelStyle: const TextStyle(color: Colors.black87),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(color: Colors.deepPurple),
    ),

    scaffoldBackgroundColor: const Color(0xFFF5F3FF),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.dark(
      primary: Colors.deepPurple,
      secondary: Colors.purpleAccent,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFB39DDB), Color(0xFFEDE7F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
