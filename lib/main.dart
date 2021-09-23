import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/pseudo_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PseudoHome pseudoHome = Get.put(const PseudoHome());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: pseudoHome,
    );
  }
}
