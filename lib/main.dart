import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/screens/main_navigation_screen.dart';

// Globalny Notifier do zmiany motywu (Ekran Ustawień)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    // Rejestrowanie błędów w Firebase Crashlytics (1. usługa Firebase)
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (_) {}

  await Hive.initFlutter();
  // Otwieramy boxy dla nowych funkcjonalności
  await Hive.openBox<bool>('favorites_box');
  await Hive.openBox<bool>('settings_box');

  // Wczytanie zapisanego motywu
  final settingsBox = Hive.box<bool>('settings_box');
  final isDarkMode = settingsBox.get('is_dark_mode', defaultValue: false) ?? false;
  themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Kraje Świata',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: currentMode,
          home: const MainNavigationScreen(), // Zmieniony ekran startowy
        );
      },
    );
  }
}