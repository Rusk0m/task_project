import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_repository/settings_repository.dart';


class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepository repository;

  ThemeCubit(this.repository) : super(ThemeMode.system) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final theme = await repository.getTheme();
    emit(theme);
  }

  Future<void> toggleTheme(ThemeMode theme) async {
    await repository.saveTheme(theme);
    emit(theme);
  }
}
