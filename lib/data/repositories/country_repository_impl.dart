@override
Future<List<Country>> getCountries() async {
  if (await networkInfo.isConnected) {
    try {
      final remoteCountries = await remoteDataSource.getAllCountries();

      await localDataSource.cacheCountries(remoteCountries);

      return remoteCountries;
    } catch (e) {
      return await localDataSource.getCachedCountries();
    }
  } else {
    return await localDataSource.getCachedCountries();
  }
}