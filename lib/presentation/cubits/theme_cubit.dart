import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box _settingsBox;

  ThemeCubit(this._settingsBox)
      : super(_loadInitialTheme(_settingsBox));

  static ThemeMode _loadInitialTheme(Box box) {
    final stored = box.get('theme');
    if (stored == 'light') return ThemeMode.light;
    if (stored == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void toggleTheme() {
    final newTheme =
    state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Сохраняем в Hive
    _settingsBox.put('theme', newTheme == ThemeMode.light ? 'light' : 'dark');

    emit(newTheme);
  }
}