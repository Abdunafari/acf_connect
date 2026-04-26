import 'package:flutter/material.dart';

class AppColors {
  static const Color kanoGreen = Color(0xFF008751); // Nigeria Green / Kano theme
  static const Color primaryGreen = Color(0xFF075E54); // WhatsApp Dark Green
  static const Color secondaryGreen = Color(0xFF25D366); // WhatsApp Light Green
  static const Color backgroundWhite = Color(0xFFF0F2F5);
  static const Color bubbleSent = Color(0xFFE7FFDB);
  static const Color bubbleReceived = Colors.white;
  static const Color textBlack = Color(0xFF303030);
  static const Color textGrey = Color(0xFF667781);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.kanoGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kanoGreen,
        primary: AppColors.kanoGreen,
        secondary: AppColors.secondaryGreen,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kanoGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
