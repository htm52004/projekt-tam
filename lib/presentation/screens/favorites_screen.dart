import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ulubione')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<bool>('favorites_box').listenable(),
        builder: (context, Box<bool> box, _) {
          final favorites = box.keys.where((key) => box.get(key) == true).toList();
          if (favorites.isEmpty) return const Center(child: Text('Brak ulubionych krajów.'));

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index].toString()),
                leading: const Icon(Icons.favorite, color: Colors.red),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => box.put(favorites[index], false),
                ),
              );
            },
          );
        },
      ),
    );
  }
}