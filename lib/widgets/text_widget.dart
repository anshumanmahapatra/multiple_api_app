import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constant.dart';

class TextWidget {
  ColorConstant constant = Get.put(ColorConstant());

  Widget getGenderTextWidget(String val) {
      return Text(
        val,
        style: TextStyle(color: constant.textColor),
      );
  }
}
