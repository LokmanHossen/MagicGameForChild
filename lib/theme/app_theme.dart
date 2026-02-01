import 'package:flutter/material.dart';

class AppTheme {
  // Kid-friendly color palette
  static const Color primaryColor = Color(0xFFFF6B9D); // Pink
  static const Color secondaryColor = Color(0xFF4ECDC4); // Turquoise
  static const Color accentColor = Color(0xFFFFA07A); // Light Salmon
  static const Color backgroundColor = Color(0xFFFFF9E6); // Cream
  static const Color cardColor = Color(0xFFFFFFFF);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE91E63);

  // Game area colors
  static const Color abcColor = Color(0xFFFF6B9D);
  static const Color numberColor = Color(0xFF4ECDC4);
  static const Color animalColor = Color(0xFF95E1D3);
  static const Color colorGameColor = Color(0xFFFFA07A);
  static const Color puzzleColor = Color(0xFFAA96DA);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Comic Sans MS',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      error: errorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2C3E50),
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF34495E),
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 18,
    color: Color(0xFF2C3E50),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle gameTextStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2C3E50),
  );
}
