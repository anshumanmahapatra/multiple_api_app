import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../screens/age_screen.dart';
import '../screens/country_screen.dart';
import '../screens/gender_screen.dart';
import '../controller/controller.dart';

class PseudoHome extends StatelessWidget {
  const PseudoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    GenderScreen genderScreen = Get.put(const GenderScreen());
    AgeScreen ageScreen = Get.put(const AgeScreen());
    CountryScreen countryScreen = Get.put(const CountryScreen());

    List<Widget> screens = [
      genderScreen,
      ageScreen,
      countryScreen,
    ];

    return Scaffold(bottomNavigationBar: Obx(() {
      return BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.venusMars), label: 'Gender'),
          BottomNavigationBarItem(
              icon: Icon(Icons.elderly_outlined), label: 'Age'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag_outlined), label: 'Country'),
        ],
        onTap: (index) {
          controller.changeIndex(index);
          controller.saveGenderName("");
          controller.saveAgeName("");
          controller.saveCountryName("");
        },
        currentIndex: controller.currentIndex.value,
      );
    }), body: Obx(() {
      return screens[controller.currentIndex.value];
    }));
  }
}
