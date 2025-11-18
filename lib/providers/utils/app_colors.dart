import 'package:flutter/material.dart';

class AppColors {
  // Gradientes principales
  static const List<Color> primaryGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFf093fb),
  ];

  static const List<Color> buttonGradient = [
    Color(0xFF9C27B0),
    Color(0xFF2196F3),
    Color(0xFFBA68C8),
  ];

  // Colores base
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightPurple = Color(0xFFBA68C8);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;
  
  // Colores de fondo
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  
  // Colores de estado
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  
  // Sombras
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.1),
      blurRadius: 5,
      offset: const Offset(0, -2),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryPurple.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}