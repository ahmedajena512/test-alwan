import 'package:flutter/material.dart';

/// App color constants matching the logo gradient colors
class AppColors {
  // Logo gradient colors
  static const Color green = Color(0xFF34D47F);
  static const Color cyan = Color(0xFF21C0E5);
  static const Color blue = Color(0xFF1389C6);

  // New Design Colors
  static const Color primary = Color(0xFF22d3ee);
  static const Color secondary = Color(0xFF4ade80);
  static const Color primaryDark = Color(0xFF0e7490);
  static const Color backgroundLight = Color(0xFFf8fafc);
  static const Color cardLight = Color(0xFFffffff);
  static const Color textLight = Color(0xFF334155);
  static const Color textMutedLight = Color(0xFF64748b);

  /// Main gradient matching the logo (green -> cyan -> blue)
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary, primary],
  );

  /// Vertical gradient variant
  static const LinearGradient verticalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondary, primary],
  );
}
