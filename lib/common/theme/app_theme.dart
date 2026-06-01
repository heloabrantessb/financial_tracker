import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A); // Premium Navy Blue (Azul Marinho)
  static const Color secondary = Color(0xFFEF4444); // Modern Vibrant Red (Vermelho para Despesas)
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
}

// Light Theme
final ThemeData appLightTheme = _buildTheme(Brightness.light);

// Dark Theme
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);

// Função que monta os dois temas
ThemeData _buildTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: brightness,
    secondary: AppColors.secondary,
    surface: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: colorScheme.onSurface),
      headlineMedium: TextStyle(color: colorScheme.onSurface),
      titleLarge: TextStyle(color: colorScheme.onSurface),
      bodyLarge: TextStyle(color: colorScheme.onSurface),
      bodyMedium: TextStyle(color: colorScheme.onSurface),
      labelLarge: TextStyle(color: colorScheme.onPrimary),
    ),
  );
}