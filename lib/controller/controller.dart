import 'package:get/get.dart';
import 'package:multiple_api_app/models/code_to_country_model.dart';
import 'package:multiple_api_app/services/code_to_country_api.dart';
import '../models/name_to_code_model.dart';
import '../services/name_to_code_api.dart';

import '../models/age_model.dart';
import '../models/gender_model.dart';

import '../services/gender_api.dart';
import '../services/age_api.dart';

class Controller extends GetxController {
  var currentIndex = 0.obs;
  var genderName = "".obs;
  var ageName = "".obs;
  var countryName = "".obs;
  var doNotShowGender = true.obs;
  var isLoadingGender = false.obs;
  Future<GenderModel>? genderData;
  Future<AgeModel>? ageData;
  Future<NameToCodeModel>? countryIdData;
  Future<List<CodeToCountryModel>>? countryNameData;

  changeIndex(int index) {
    currentIndex.value = index;
  }

  saveGenderName(String val) {
    genderName.value = val;
  }

  saveAgeName(String val) {
    ageName.value = val;
  }

  saveCountryName(String val) {
    countryName.value = val;
  }

  changeIsLoadingGender(bool val) {
    isLoadingGender.value = val;
  }

  changeDoNotShowGender(bool val) {
    doNotShowGender.value = val;
  }

  getGender(String val) {
    genderData = GenderApi.getGender(val);
  }

  getAge(String val) {
    ageData = AgeApi.getAge(val);
  }

  getCountryId(String val) {
    countryIdData = NameToCodeApi.getCountryId(val);
  }

  getCountryName(List<Country> data) {
    countryNameData = CodeToCountryApi.getCountryName(data);
  }
}
