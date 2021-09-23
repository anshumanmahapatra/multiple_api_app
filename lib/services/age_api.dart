import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/age_model.dart';

class AgeApi {
  static Future<AgeModel> getAge(String name) async {
    final response =
        await http.get(Uri.parse("https://api.agify.io/?name=$name"));
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return AgeModel.fromJson(result);
    } else {
      throw Exception('Failed to Load Age');
    }
  }
}
