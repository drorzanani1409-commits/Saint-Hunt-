import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppConstants.darkTeal,
      scaffoldBackgroundColor: AppConstants.parchment,
      fontFamily: AppConstants.bodyFont,
      
      colorScheme: ColorScheme.light(
        primary: AppConstants.darkTeal,
        secondary: AppConstants.gold,
        background: AppConstants.parchment,
        surface: AppConstants.parchment,
        error: const Color(0xFF8B0000),
        onPrimary: AppConstants.gold,
        onSecondary: AppConstants.darkTeal,
        onBackground: AppConstants.brownText,
        onSurface: AppConstants.brownText,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.darkTeal,
        foregroundColor: AppConstants.gold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.headingFont,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConstants.gold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.headingFont,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppConstants.brownText,
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.headingFont,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.brownText,
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.headingFont,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConstants.brownText,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.brownText,
        ),
        titleLarge: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.brownText,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 16,
          color: AppConstants.brownText,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 14,
          color: AppConstants.brownText,
        ),
        labelLarge: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.gold,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.scrollworkBrown,
          foregroundColor: AppConstants.gold,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontFamily: AppConstants.bodyFont,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.parchment.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppConstants.brownText, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppConstants.brownText, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppConstants.darkTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8B0000), width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 16,
          color: AppConstants.brownText,
        ),
        hintStyle: TextStyle(
          fontFamily: AppConstants.bodyFont,
          fontSize: 14,
          color: AppConstants.brownText.withOpacity(0.5),
        ),
      ),
      
      cardTheme: CardThemeData(
        color: AppConstants.parchment,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppConstants.scrollworkBrown, width: 2),
        ),
      ),
      
      iconTheme: IconThemeData(
        color: AppConstants.gold,
        size: 24,
      ),
    );
  }
}

