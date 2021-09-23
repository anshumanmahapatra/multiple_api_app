import '../models/gender_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GenderApi {
  static Future<GenderModel> getGender(String name) async {
    final response =
        await http.get(Uri.parse("https://api.genderize.io/?name=$name"));
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return GenderModel.fromJson(result);
    } else {
      throw Exception('Failed to predict the Gender');
    }
  }
}
