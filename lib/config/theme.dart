import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFFFA726);
  static const Color secondaryColor = Color(0xFF222222);
  static const Color backgroundColor = Colors.white;
  static const Color cardBackground = Color(0xFFEEE5D6);

  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.jomolhari().fontFamily,
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        background: cardBackground,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: GoogleFonts.jomolhari().fontFamily,
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: cardBackground,
        surface: secondaryColor,
        background: secondaryColor,
      ),
    );
  }
}