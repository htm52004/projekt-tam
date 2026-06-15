import 'package:hive_flutter/hive_flutter.dart';
import '../models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  static const String _countriesBoxName = 'cached_countries_box';

  @override
  Future<List<CountryModel>> getCachedCountries() async {
    final box = await Hive.openBox(_countriesBoxName);
    final List<dynamic>? rawData = box.get('countries_list');
    if (rawData == null || rawData.isEmpty) {
      throw Exception('Brak zapisanych danych lokalnych.');
    }
    return rawData
        .map((dynamic item) => CountryModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    final box = await Hive.openBox(_countriesBoxName);
    final dataToCache = countries.map((country) => country.toJson()).toList();
    await box.put('countries_list', dataToCache);
  }
}