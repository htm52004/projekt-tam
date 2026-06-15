import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../data/models/country_model.dart';

class CountryDetailsScreen extends StatelessWidget {
  final CountryModel country;

  const CountryDetailsScreen({super.key, required this.country});

  void _toggleFavorite(BuildContext context) async {
    final box = Hive.box<bool>('favorites_box');
    final isFav = box.get(country.name, defaultValue: false) ?? false;
    await box.put(country.name, !isFav);

    await FirebaseAnalytics.instance.logEvent(
      name: 'toggle_favorite',
      parameters: {
        'country_name': country.name,
        'is_favorite': (!isFav).toString(),
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(!isFav ? 'Dodano do ulubionych!' : 'Usunięto z ulubionych'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            country.flagUrl.startsWith('http')
                ? Image.network(
              country.flagUrl,
              width: 200,
              errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 100),
            )
                : Text(
              country.flagUrl.isNotEmpty ? country.flagUrl : '🏳️',
              style: const TextStyle(fontSize: 120),
            ),
            const SizedBox(height: 24),
            Text(
              'Kraj: ${country.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Stolica: ${country.capital}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: Hive.box<bool>('favorites_box').listenable(),
        builder: (context, Box<bool> box, _) {
          final isFav = box.get(country.name, defaultValue: false) ?? false;
          return FloatingActionButton(
            onPressed: () => _toggleFavorite(context),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          );
        },
      ),
    );
  }
}