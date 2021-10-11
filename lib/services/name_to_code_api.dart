import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/name_to_code_model.dart';

class NameToCodeApi {
  static Future<NameToCodeModel> getCountryId(String name) async {
    final response =
        await http.get(Uri.parse("https://api.nationalize.io/?name=$name"));
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return NameToCodeModel.fromJson(result);
    } else {
      throw Exception('Failed to Load Country');
    }
  }
}
