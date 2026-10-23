import 'package:flutter/material.dart';

abstract final class AppColors {
  static const purple = Color(0xFF7C6AF3);
  static const blue = Color(0xFF44A5F5);
  static const ink = Color(0xFF2F2F2F);
  static const muted = Color(0xFFA1A1A1);
  static const field = Color(0xFFF5F5FA);
  static const gradient = LinearGradient(colors: [purple, blue]);
  static const shadow = BoxShadow(
    color: Color(0x18000000),
    blurRadius: 38,
    offset: Offset(0, 14),
  );
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.purple,
    primary: AppColors.purple,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.muted),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.field,
    hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.purple),
    ),
  ),
  dividerColor: const Color(0xFFF0F0F2),
);
