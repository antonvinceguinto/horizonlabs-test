import 'package:flutter/material.dart';

abstract class IThemeService {
  ThemeMode themeMode() => ThemeMode.light;
  bool isDarkMode();
  Future<void> updateThemeMode();
}
