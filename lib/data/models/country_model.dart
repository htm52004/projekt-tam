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
    if (json['names'] is Map && json['names']['common'] != null) {
      countryName = json['names']['common'].toString();
    } else if (json['name'] is Map && json['name']['common'] != null) {
      countryName = json['name']['common'].toString();
    } else if (json['names.common'] != null) {
      countryName = json['names.common'].toString();
    }

    String countryCapital = 'Brak stolicy';
    final caps = json['capitals'] ?? json['capital'];
    if (caps is List && caps.isNotEmpty) {
      final firstCap = caps[0];
      if (firstCap is Map && firstCap['name'] != null) {
        countryCapital = firstCap['name'].toString();
      } else if (firstCap is String) {
        countryCapital = firstCap;
      }
    } else if (caps is String) {
      countryCapital = caps;
    }

    String flag = '🏳️';
    if (json['flag'] is Map && json['flag']['emoji'] != null) {
      flag = json['flag']['emoji'].toString();
    } else if (json['flags'] is Map && json['flags']['png'] != null) {
      flag = json['flags']['png'].toString();
    } else if (json['flag.emoji'] != null) {
      flag = json['flag.emoji'].toString();
    } else if (json['flags.png'] != null) {
      flag = json['flags.png'].toString();
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