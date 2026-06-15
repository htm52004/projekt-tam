class CountryModel {
  final String name;
  final String capital;
  final String flagUrl;

  CountryModel({
    required this.name,
    required this.capital,
    required this.flagUrl,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    String countryName = 'Brak nazwy';
    if (json['name'] != null && json['name']['common'] != null) {
      countryName = json['name']['common'].toString();
    }

    String countryCapital = 'Brak stolicy';
    if (json['capital'] != null && json['capital'] is List && (json['capital'] as List).isNotEmpty) {
      countryCapital = json['capital'][0].toString();
    }

    String flag = '';
    if (json['flags'] != null && json['flags']['png'] != null) {
      flag = json['flags']['png'].toString();
    }

    return CountryModel(
      name: countryName,
      capital: countryCapital,
      flagUrl: flag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'capital': [capital],
      'flags': {'png': flagUrl},
    };
  }
}