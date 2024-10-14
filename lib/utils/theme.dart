import 'package:ecommerce_store/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final themeData = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 26.0,
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 24.0,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontSize: 16.0,
        color: AppColors.grey,
      ),
      displayMedium: TextStyle(
        fontSize: 16.0,
        color: AppColors.black,
      ),
      labelMedium: TextStyle(
        fontSize: 23.0,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.black,
      contentTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 16.0,
      ),
    ),
    useMaterial3: true,
  );
}
