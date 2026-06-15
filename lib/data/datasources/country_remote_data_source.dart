import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();

  Future<CountryModel> getCountryByCode(String code);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://restcountries.com/v3.1';

  CountryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    final response = await client.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Błąd pobierania listy krajów');
    }
  }

  @override
  Future<CountryModel> getCountryByCode(String code) async {
    final response = await client.get(Uri.parse('$baseUrl/alpha/$code'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return CountryModel.fromJson(jsonList.first);
    } else {
      throw Exception('Błąd pobierania szczegółów kraju $code');
    }
  }
}