import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final http.Client client;

  CountryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await client.get(
        Uri.parse('https://restcountries.com/v3.1/all?fields=name,capital,flags'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Connection': 'keep-alive',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          final List<CountryModel> countries = [];
          for (var item in decodedData) {
            if (item is Map<String, dynamic>) {
              try {
                countries.add(CountryModel.fromJson(item));
              } catch (_) {}
            }
          }
          return countries;
        } else if (decodedData is Map<String, dynamic>) {
          final errorMessage = decodedData['message'] ?? decodedData['error'] ?? 'Blad konfiguracji serwera RestCountries';
          throw Exception(errorMessage);
        } else {
          throw Exception('Nieoczekiwany format danych JSON');
        }
      } else {
        try {
          final dynamic errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            throw Exception('Blad ${response.statusCode}: ${errorBody['message']}');
          }
        } catch (_) {}
        throw Exception('Serwer zwrocil kod bledu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('REST_COUNTRIES_CRASH: $e');
    }
  }
}