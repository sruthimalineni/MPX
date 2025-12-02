import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xffDFF8C8),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xffFF6B6B),
        secondary: Color(0xffA3F7BF),
      ),
    );
  }
}
