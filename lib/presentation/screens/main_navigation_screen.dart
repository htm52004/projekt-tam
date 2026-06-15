import 'package:flutter/material.dart';
import 'countries_list_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const CountriesListScreen(),
    const FavoritesScreen(), // Ekran 3
    const SettingsScreen(),  // Ekran 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Ulubione'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ustawienia'),
        ],
      ),
    );
  }
}