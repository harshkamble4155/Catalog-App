import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeNotifier = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeBox = "theme_box";
  static const _themeKey = "theme_key";
  static Box? _box;

  ThemeNotifier() : super(ThemeMode.system) {
    final modeIndex = _box?.get(_themeKey) as int?;
    if (modeIndex != null) {
      state = ThemeMode.values[modeIndex];
    }
  }

  static Future initHive() async {
    _box = await Hive.openBox(_themeBox);
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    _box?.put(_themeKey, state.index);
  }

  ThemeMode isDarkMode() {
    return state;
  }
}
