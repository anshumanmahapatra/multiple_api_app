class GenderModel {
  final String name;
  final String gender;
  final double probability;
  GenderModel(
      {required this.name, required this.gender, required this.probability});

  factory GenderModel.fromJson(Map json) {
    return GenderModel(
        name: json['name'].toString(),
        gender: json['gender'] ?? 'Gender Could Not be determined',
        probability: double.parse(json['probability'].toString()));
  }
}
