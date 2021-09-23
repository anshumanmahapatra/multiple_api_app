class CodeToCountryModel {
  final String countryName;
  CodeToCountryModel({required this.countryName});

  factory CodeToCountryModel.fromJson(Map json) {
    return CodeToCountryModel(countryName: json['name']['common'] ?? "NA");
  }

  static List<CodeToCountryModel> getCountryNameFromId(List data) {
    return data.map((e) => CodeToCountryModel.fromJson(e)).toList();
  }
}
