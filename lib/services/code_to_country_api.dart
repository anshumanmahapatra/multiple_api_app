import 'package:flutter/material.dart';
import 'package:multiple_api_app/models/code_to_country_model.dart';
import 'package:multiple_api_app/models/name_to_code_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeToCountryApi {
  static Future<List<CodeToCountryModel>> getCountryName(
      List<Country> data) async {
    String baseUrl = "https://restcountries.com/v3/alpha?codes=";
    int i = 0;
    for (i = 0; i < data.length; i++) {
      baseUrl = baseUrl + data.elementAt(i).countryId + ",";
    }
    debugPrint(baseUrl);
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      return CodeToCountryModel.getCountryNameFromId(result);
    } else {
      throw Exception("Failed to Load Country Name");
    }
  }
}
