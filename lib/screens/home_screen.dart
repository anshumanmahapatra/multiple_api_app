import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constant.dart';

import '../models/gender_model.dart';
import '../models/age_model.dart';
import '../models/code_to_country_model.dart';
import '../models/name_to_code_model.dart';

import '../widgets/loading_widget.dart';

import '../controller/controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Controller controller = Get.put(Controller());
    ColorConstant constant = Get.put(ColorConstant());
    LoadingWidget loadingWidget = Get.put(LoadingWidget());
    TextStyle errorTextStyle = TextStyle(color: constant.textColor);
    return Scaffold(
        backgroundColor: constant.kPrimary,
        appBar: AppBar(
          title: const Text('Get Details from Name'),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: constant.kSecondary,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: constant.textColor),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: constant.textColor)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      hintText: 'Enter a Name to get the Details',
                      hintStyle: TextStyle(color: constant.textColor),
                    ),
                    onSaved: (val) {
                      controller.saveName(val!);
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter a Name';
                      } else if (val.isPhoneNumber) {
                        return 'Please enter a Name instead of a Phone Number';
                      } else if (val.isEmail) {
                        return 'Please enter a Name instead of an Email';
                      } else if (val.isNumericOnly) {
                        return 'Please enter a Name instead of a Number';
                      } else {
                        int i;
                        int count = 0;
                        for (i = 0; i < val.length; i++) {
                          if (val.substring(i, i + 1) == " ") {
                            count = count + 1;
                          }
                        }
                        debugPrint(count.toString());
                        if (count == val.length) {
                          return 'Please enter a name';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text("Get Details"),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          controller.getGender(controller.name.value);
                          controller.revertToOriginal();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(color: constant.textColor))),
                  const SizedBox(height: 40),
                  Obx(() {
                    return Offstage(
                      offstage: controller.name.value == "",
                      child: FutureBuilder<GenderModel>(
                        future: controller.genderData,
                        builder: (context, snapshot1) {
                          if (snapshot1.connectionState ==
                                  ConnectionState.active ||
                              snapshot1.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot1.hasError) {
                              debugPrint(snapshot1.error.toString());
                              return Text(snapshot1.error.toString(),
                                  style: errorTextStyle);
                            } else {
                              debugPrint("Got Gender data");
                              controller.swapValues();
                              controller.setLoadingText(2);
                              controller.changeWidth();
                              controller.getAge(controller.name.value);

                              return FutureBuilder<AgeModel>(
                                future: controller.ageData,
                                builder: (context, snapshot2) {
                                  if (snapshot2.connectionState ==
                                          ConnectionState.active ||
                                      snapshot2.connectionState ==
                                          ConnectionState.done) {
                                    if (snapshot2.hasError) {
                                      debugPrint(snapshot2.error.toString());
                                      return Text(
                                          "Sorry we could not process your input",
                                          style: errorTextStyle);
                                    } else {
                                      debugPrint("Got Age Data");
                                      controller.swapValues();
                                      controller.setLoadingText(3);
                                      controller.changeWidth();
                                      controller
                                          .getCountryId(controller.name.value);

                                      return FutureBuilder<NameToCodeModel>(
                                        future: controller.countryIdData,
                                        builder: (context, snapshot3) {
                                          if (snapshot3.connectionState ==
                                                  ConnectionState.active ||
                                              snapshot3.connectionState ==
                                                  ConnectionState.done) {
                                            if (snapshot3.hasError) {
                                              debugPrint(
                                                  "We had error processing data from nationalize api. And the problem is:");
                                              debugPrint(
                                                  snapshot3.error.toString());
                                              return Text(
                                                  "Sorry we could not process your input",
                                                  style: errorTextStyle);
                                            } else {
                                              debugPrint("Got Country Id Data");
                                              controller.swapValues();
                                              controller.setLoadingText(4);
                                              controller.changeWidth();
                                              controller.getCountryName(
                                                  snapshot3.data!.countryId);
                                                  
                                              return FutureBuilder<
                                                      List<CodeToCountryModel>>(
                                                  future: controller
                                                      .countryNameData,
                                                  builder:
                                                      (context, snapshot4) {
                                                    if (snapshot4
                                                                .connectionState ==
                                                            ConnectionState
                                                                .active ||
                                                        snapshot4
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                      if (snapshot4.hasError) {
                                                        debugPrint(
                                                            "Got Error while getting Country Name. And that error is:");
                                                        debugPrint(snapshot4
                                                            .error
                                                            .toString());
                                                        return Text(
                                                            "Sorry we could not process your input",
                                                            style:
                                                                errorTextStyle);
                                                      } else {
                                                        debugPrint(
                                                            "Got Country Name data");

                                                        controller
                                                            .mergeCountryNames(
                                                                snapshot4
                                                                    .data!);
                                                        Color resultTextColor;
                                                        if (snapshot1
                                                                .data!.gender ==
                                                            "male") {
                                                          resultTextColor =
                                                              Colors.blue;
                                                        } else {
                                                          resultTextColor =
                                                              constant
                                                                  .kPurpleColor;
                                                        }
                                                        return Column(
                                                          children: [
                                                            Text(
                                                              controller
                                                                      .name
                                                                      .value
                                                                      .capitalizeFirst! +
                                                                  "'s Details",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: constant
                                                                      .textColor),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            ListTile(
                                                              leading: Text(
                                                                "Gender",
                                                                style: TextStyle(
                                                                    color: constant
                                                                        .textColor),
                                                              ),
                                                              trailing: Text(
                                                                snapshot1
                                                                    .data!
                                                                    .gender
                                                                    .capitalizeFirst!,
                                                                style: TextStyle(
                                                                    color:
                                                                        resultTextColor),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            ListTile(
                                                              leading: Text(
                                                                "Age",
                                                                style: TextStyle(
                                                                    color: constant
                                                                        .textColor),
                                                              ),
                                                              trailing: Text(
                                                                snapshot2
                                                                    .data!.age
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color:
                                                                        resultTextColor),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            ListTile(
                                                              leading: Text(
                                                                "Country",
                                                                style: TextStyle(
                                                                    color: constant
                                                                        .textColor),
                                                              ),
                                                              trailing:
                                                                  ConstrainedBox(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxWidth:
                                                                            150),
                                                                child: Text(
                                                                  controller
                                                                      .allCountryNames
                                                                      .value,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      color:
                                                                          resultTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    } else if (snapshot4
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      debugPrint(
                                                          "Waiting for Country Name data");
                                                      return loadingWidget
                                                          .getLoadingWidget();
                                                    } else {
                                                      debugPrint(
                                                          "Got Nothing to Show 2");
                                                      debugPrint(
                                                          "Snapshot state: " +
                                                              snapshot4
                                                                  .connectionState
                                                                  .toString());
                                                      return Container();
                                                    }
                                                  });
                                            }
                                          } else if (snapshot3
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            debugPrint(
                                                "Waiting for Country Id data");
                                            return loadingWidget
                                                .getLoadingWidget();
                                          } else {
                                            debugPrint("Snapshot state: " +
                                                snapshot3.connectionState
                                                    .toString());
                                            debugPrint("Got Nothing to show 1");
                                            return Container();
                                          }
                                        },
                                      );
                                    }
                                  } else if (snapshot2.connectionState ==
                                      ConnectionState.waiting) {
                                    debugPrint("Waiting for Age data");
                                    return loadingWidget.getLoadingWidget();
                                  } else {
                                    debugPrint("Snapshot state: " +
                                        snapshot2.connectionState.toString());
                                    debugPrint("Got Nothing to show");
                                    return Container();
                                  }
                                },
                              );
                            }
                          } else if (snapshot1.connectionState ==
                              ConnectionState.waiting) {
                            debugPrint("Waiting for Gender data");
                            controller.setLoadingText(1);
                            return loadingWidget.getLoadingWidget();
                          } else {
                            debugPrint("Snapshot state: " +
                                snapshot1.connectionState.toString());
                            debugPrint("Got Nothing to show");
                            return Container();
                          }
                        },
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ));
  }
}
