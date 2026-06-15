import '../datasources/country_remote_data_source.dart';
import '../datasources/country_local_data_source.dart';
import '../models/country_model.dart';

class CountryRepositoryImpl {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<CountryModel>> getAllCountries() async {
    try {
      final remoteCountries = await remoteDataSource.getAllCountries();
      try {
        await localDataSource.cacheCountries(remoteCountries);
      } catch (_) {}
      return remoteCountries;
    } catch (remoteError) {
      // DODANY PRINT BŁĘDÓW SIECIOWYCH:
      print('====== BŁĄD SIECIOWY: $remoteError ======');

      try {
        final localCountries = await localDataSource.getCachedCountries();
        if (localCountries.isNotEmpty) {
          return localCountries;
        }
      } catch (_) {}
      throw Exception('Błąd pobierania z sieci: $remoteError');
    }
  }
}