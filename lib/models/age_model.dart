class AgeModel {
  final String name;
  final int age;

  AgeModel({required this.name, required this.age});

  factory AgeModel.fromJson(Map json) {
    return AgeModel(name: json['name'].toString(), age: json['age']);
  }
}
