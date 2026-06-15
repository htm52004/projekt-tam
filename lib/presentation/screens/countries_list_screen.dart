import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/country_remote_data_source.dart';
import '../../data/datasources/country_local_data_source.dart';
import '../../data/repositories/country_repository_impl.dart';
import '../../data/models/country_model.dart';

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

  Future<void> _handleRefresh() async {
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
      body: RefreshIndicator(
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
                    const Text('Brak danych do wyświetlenia.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadCountries,
                      child: const Text('Odśwież'),
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
                      child: Image.network(
                        country.flagUrl,
                        width: 50,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 40),
                      ),
                    ),
                    title: Text(
                      country.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Stolica: ${country.capital}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}