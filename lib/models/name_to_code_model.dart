class NameToCodeModel {
  final String name;
  final List<Country> countryId;

  NameToCodeModel({required this.name, required this.countryId});

  static List<Country> getCountryList(List data) {
    return data.map((e) => Country.fromJson(e)).toList();
  }

  factory NameToCodeModel.fromJson(Map json) {
    return NameToCodeModel(
        name: json['name'], countryId: getCountryList(json['country']));
  }
}

class Country {
  final String countryId;
  final double probability;

  Country({
    required this.countryId,
    required this.probability,
  });

  factory Country.fromJson(Map json) => Country(
        countryId: json["country_id"],
        probability: double.parse(json['probability'].toString()),
      );
}
