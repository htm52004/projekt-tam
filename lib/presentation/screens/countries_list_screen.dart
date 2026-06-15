import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../data/datasources/country_remote_data_source.dart';
import '../../data/datasources/country_local_data_source.dart';
import '../../data/repositories/country_repository_impl.dart';
import '../../data/models/country_model.dart';
import 'country_details_screen.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  final CountryRepositoryImpl _repository = CountryRepositoryImpl(
    remoteDataSource: CountryRemoteDataSourceImpl(client: http.Client()),
    localDataSource: CountryLocalDataSourceImpl(),
  );

  late Future<List<CountryModel>> _countriesFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  void _loadCountries() {
    setState(() {
      _countriesFuture = _repository.getAllCountries();
    });
  }

  void _searchCountries(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _countriesFuture = _repository.getAllCountries();
      } else {
        _countriesFuture = _repository.searchCountries(query.trim());
      }
    });
  }

  Future<void> _handleRefresh() async {
    await FirebaseAnalytics.instance.logEvent(name: 'manual_refresh_triggered');
    _searchController.clear();
    _loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kraje Świata', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  labelText: 'Szukaj państwa (wciśnij enter)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _loadCountries();
                    },
                  )
              ),
              onSubmitted: _searchCountries,
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: FutureBuilder<List<CountryModel>>(
                future: _countriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Pobieranie danych ze świata...'),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Coś poszło nie tak!\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _loadCountries,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Spróbuj ponownie'),
                            )
                          ],
                        ),
                      ),
                    );
                  }

                  final countries = snapshot.data ?? [];

                  if (countries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Brak wyników wyszukiwania.'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadCountries,
                            child: const Text('Wróć do pełnej listy'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: country.flagUrl.startsWith('http')
                                ? Image.network(
                              country.flagUrl,
                              width: 50,
                              height: 35,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 40),
                            )
                                : Text(
                              country.flagUrl.isNotEmpty ? country.flagUrl : '🏳️',
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                          title: Text(
                            country.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Stolica: ${country.capital}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () async {
                            await FirebaseAnalytics.instance.logEvent(
                              name: 'view_country_details',
                              parameters: {'country_name': country.name},
                            );

                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CountryDetailsScreen(country: country),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}