import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:settings_repository/settings_repository.dart';

class LocaleCubit extends Cubit<Locale?> {
  final SettingsRepository repository;

  LocaleCubit(this.repository) : super(null) {
    loadLocale();
  }

  Future<void> loadLocale() async {
    final locale = await repository.getLocale();
    emit(locale);
  }

  Future<void> changeLocale(Locale locale) async {
    await repository.saveLocale(locale);
    emit(locale);
  }
}