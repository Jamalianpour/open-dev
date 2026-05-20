import 'package:flutter/material.dart';

/// App-wide theme mode. Toggled from the side menu; consumed by [MaterialApp]
/// via [ValueListenableBuilder] in `main.dart`.
final ValueNotifier<ThemeMode> themeMode =
    ValueNotifier<ThemeMode>(ThemeMode.dark);

void toggleThemeMode() {
  themeMode.value =
      themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}
