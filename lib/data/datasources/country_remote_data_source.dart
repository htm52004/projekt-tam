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
      final url = 'https://api.restcountries.com/countries/v5?limit=100';

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer rc_live_e20c8b9549394d91adb151d5770e1be6',
        },
      );

      final dynamic decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
          final dataMap = decodedData['data'] as Map<String, dynamic>;
          final objectsList = dataMap['objects'] as List<dynamic>? ?? [];

          final List<CountryModel> countries = [];
          for (var item in objectsList) {
            if (item is Map<String, dynamic>) {
              try {
                countries.add(CountryModel.fromJson(item));
              } catch (_) {}
            }
          }
          return countries;
        } else {
          throw Exception('Nieoczekiwany format danych JSON z v5');
        }
      } else {
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('errors')) {
          final errors = decodedData['errors'] as List<dynamic>;
          if (errors.isNotEmpty) {
            throw Exception(errors[0]['message']);
          }
        }
        throw Exception('Serwer zwrócił kod błędu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('REST_COUNTRIES_CRASH: $e');
    }
  }
}