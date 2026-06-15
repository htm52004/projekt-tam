import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../main.dart'; // Import themeNotifier

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentMode, _) {
          final isDark = currentMode == ThemeMode.dark;
          return SwitchListTile(
            title: const Text('Tryb Ciemny'),
            subtitle: const Text('Zmień motyw aplikacji'),
            value: isDark,
            onChanged: (value) {
              themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              Hive.box<bool>('settings_box').put('is_dark_mode', value);
            },
          );
        },
      ),
    );
  }
}