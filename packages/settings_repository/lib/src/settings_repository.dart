import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {

  static const _themeKey = 'theme';
  static const _localeKey = 'locale';

  Future<ThemeMode> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'system';
    return ThemeMode.values.firstWhere(
          (e) => e.toString() == 'ThemeMode.$theme',
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.name);
  }

  Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_localeKey);
    return locale != null ? Locale(locale) : null;
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
