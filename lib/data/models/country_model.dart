class CountryModel {
  final String name;
  final String flagUrl;
  final String capital;
  final String currencyName;
  final String language;
  final String cca2;

  CountryModel({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.currencyName,
    required this.language,
    required this.cca2,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final String countryName = json['name']?['common'] ?? 'Brak nazwy';

    final String flag = json['flags']?['png'] ?? '';

    final List<dynamic>? capitals = json['capital'];
    final String countryCapital = (capitals != null && capitals.isNotEmpty)
        ? capitals.first.toString()
        : 'Brak stolicy';

    String countryCurrency = 'Brak waluty';
    final Map<String, dynamic>? currencies = json['currencies'];
    if (currencies != null && currencies.isNotEmpty) {
      final firstCurrencyKey = currencies.keys.first;
      countryCurrency = currencies[firstCurrencyKey]?['name'] ?? 'Brak waluty';
    }

    String countryLanguage = 'Brak języka';
    final Map<String, dynamic>? languages = json['languages'];
    if (languages != null && languages.isNotEmpty) {
      countryLanguage = languages.values.first.toString();
    }

    final String code = json['cca2'] ?? '';

    return CountryModel(
      name: countryName,
      flagUrl: flag,
      capital: countryCapital,
      currencyName: countryCurrency,
      language: countryLanguage,
      cca2: code,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flagUrl},
      'capital': [capital],
      'currencies': {
        'UNKNOWN': {'name': currencyName}
      },
      'languages': {'unknown': language},
      'cca2': cca2,
    };
  }
}