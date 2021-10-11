import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constant.dart';

import '../widgets/text_widget.dart';

import '../models/code_to_country_model.dart';
import '../models/name_to_code_model.dart';
import '../models/age_model.dart';
import '../models/gender_model.dart';

import '../services/code_to_country_api.dart';
import '../services/name_to_code_api.dart';
import '../services/gender_api.dart';
import '../services/age_api.dart';

class Controller extends GetxController {
  TextWidget textWidget = Get.put(TextWidget());
  ColorConstant constant = Get.put(ColorConstant());

  var name = "".obs;
  var allCountryNames = "".obs;

  var endWidth = 0.0.obs;
  var beginWidth = 0.0.obs;
  var listOfLoadingText = <String>[""].obs;
  RxList<bool> listOfShouldShowLottie = [true,true,true,true].obs;

  final listKey = GlobalKey<AnimatedListState>();

  Future<GenderModel>? genderData;
  Future<AgeModel>? ageData;
  Future<NameToCodeModel>? countryIdData;
  Future<List<CodeToCountryModel>>? countryNameData;

  changeWidth() {
    endWidth.value = endWidth.value + 51.0;
  }

  swapValues() {
    beginWidth.value = endWidth.value;
  }

  revertToOriginal() {
    beginWidth.value = 0.0;
    endWidth.value = 51.0;
    listOfLoadingText.clear();
    for(int i = 0; i<=3; i++) {
      listOfShouldShowLottie[i] = true;
    }
  }

  changeValueOfShouldShowLottie (int index) {
    listOfShouldShowLottie[index] = false;
  }

  setLoadingText(int val) {
    if (val == 1) {
      addItemToList(0, "Getting Gender...");
    } else if (val == 2) {
      removeItemFromList(0);
      addItemToList(0, "Got Gender").whenComplete(() => changeValueOfShouldShowLottie(0));
      addItemToList(1, "Getting Country Code...");
    } else if (val == 3) {
      removeItemFromList(1);
      addItemToList(1, "Got Age").whenComplete(() => changeValueOfShouldShowLottie(1));
      addItemToList(2, "Getting Country Code...");
    } else if (val == 4) {
      removeItemFromList(2);
      addItemToList(2, "Got Country Code").whenComplete(() => changeValueOfShouldShowLottie(2));
      addItemToList(3, "Getting Country Name...");
    } else {
      removeItemFromList(3);
      addItemToList(3, "Got Country Name").whenComplete(() => changeValueOfShouldShowLottie(3));
    }
  }

  removeItemFromList(int index) {
    final removedItem = listOfLoadingText[index];

    listOfLoadingText.removeAt(index);
    listKey.currentState?.removeItem(
        index,
        (context, animation) => FadeTransition(
            opacity: animation,
            child: Center(child: textWidget.getGenderTextWidget(removedItem))),
        duration: const Duration(milliseconds: 500));
  }

  Future<void> addItemToList(int index, String text) async {
    listOfLoadingText.add(text);
    listKey.currentState?.insertItem(index,
        duration: Duration(milliseconds: index % 2 == 0 ? 400 : 800));
  }

  String mergeCountryNames(List<CodeToCountryModel> data) {
    int i = 0;
    allCountryNames.value = "";
    for (i = 0; i < data.length; i++) {
      if (i < data.length - 2) {
        allCountryNames.value =
            allCountryNames.value + data.elementAt(i).countryName + ", ";
      } else if (i < data.length - 1) {
        allCountryNames.value =
            allCountryNames.value + data.elementAt(i).countryName + " or ";
      } else {
        allCountryNames.value =
            allCountryNames.value + data.elementAt(i).countryName;
      }
    }
    return allCountryNames.value;
  }

  saveName(String val) {
    name.value = val;
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
