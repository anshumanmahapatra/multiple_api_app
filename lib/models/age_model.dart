class AgeModel {
  final int age;

  AgeModel({required this.age});

  factory AgeModel.fromJson(Map json) {
    return AgeModel(age: json['age']);
  }
}
