import 'package:flutter/material.dart';

enum AppThemeMode {
  /// App follow system settings
  followSystemSettings(-1),
  /// App use dark mode
  darkMode(0),
  /// App use light mode
  lightMode(1);

  final int value;
  const AppThemeMode(this.value);

  ThemeMode toThemeMode() {
    switch (value) {
      case 0:
        return ThemeMode.dark;
      case 1:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}