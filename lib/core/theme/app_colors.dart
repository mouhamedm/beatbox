import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF14030A);
  static const primary = Color(0xFFD81B4A);
  static const primaryDark = Color(0xFF9E0F33);
  static const accent = Color(0xFFFF2A55);
  static const textSecondary = Color(0xB3FFFFFF);
  static const border = Color(0x33FFFFFF);
  static const glass = Color(0x14FFFFFF);
  static const star = Color(0xFFFFB400);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.28, 0.60, 1.0],
    colors: [
      Color(0xFF1E030B), // Sombre et feutré avec nuance bordeaux (pas trop noir)
      Color(0xFF2D0510), // Teinte bordeaux subtile
      Color(0xFF3D0614), // Ambiance bordeaux chaleureuse au centre
      Color(0xFF16030A), // Bas sombre
    ],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE0245E), Color(0xFFB0123A)],
  );

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8A0E26), Color(0xFF3A0610)],
  );
}
