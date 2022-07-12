import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/main.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  Future<void> updateThemeMode() async {
    /// Preserve the current theme mode.
    if (state == ThemeMode.light) {
      await prefs.setBool('darkMode', true);
      state = ThemeMode.dark;
    } else {
      await prefs.setBool('darkMode', false);
      state = ThemeMode.light;
    }
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((_) {
  return ThemeController();
});

final isDarkTheme = StateProvider<bool>((ref) {
  /// This provider doesn't work if we don't watch themeControllerProvider
  ref.watch(themeControllerProvider);
  final isDarkMode = prefs.getBool('darkMode') ?? false;
  return isDarkMode;
});
