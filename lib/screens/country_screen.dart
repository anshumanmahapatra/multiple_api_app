import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_api_app/models/code_to_country_model.dart';
import 'package:multiple_api_app/models/name_to_code_model.dart';
import '../controller/controller.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(title: const Text('Country Detector')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter a Name to detect the Country'),
                  onSaved: (val) {
                    controller.saveCountryName(val!);
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
                  child: const Text("What's my Country?"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      controller.getCountryId(controller.countryName.value);
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Obx(() {
                  return Offstage(
                    offstage: controller.countryName.value == "",
                    child: FutureBuilder<NameToCodeModel>(
                      future: controller.countryIdData,
                      builder: (context, snapshot1) {
                        if (snapshot1.connectionState ==
                                ConnectionState.active ||
                            snapshot1.connectionState == ConnectionState.done) {
                          if (snapshot1.hasError) {
                            debugPrint(
                                "We had error processing data from nationalize api. And the problem is:");
                            debugPrint(snapshot1.error.toString());
                            return const Text(
                                "Sorry we could not process your input");
                          } else {
                            debugPrint("Got Country Id Data");
                            controller
                                .getCountryName(snapshot1.data!.countryId);
                            return FutureBuilder<List<CodeToCountryModel>>(
                                future: controller.countryNameData,
                                builder: (context, snapshot2) {
                                  if (snapshot2.connectionState ==
                                          ConnectionState.active ||
                                      snapshot2.connectionState ==
                                          ConnectionState.done) {
                                    if (snapshot2.hasError) {
                                      debugPrint(
                                          "Got Error while getting Country Name. And that error is:");
                                      debugPrint(snapshot2.error.toString());
                                      return const Text(
                                          "Sorry we could not process your input");
                                    } else {
                                      debugPrint("Got Country Name data");
                                      String countryNames = "";
                                      int i = 0;
                                      for (i = 0;
                                          i < snapshot2.data!.length;
                                          i++) {
                                        if (i < snapshot2.data!.length - 2) {
                                          countryNames = countryNames +
                                              snapshot2.data!
                                                  .elementAt(i)
                                                  .countryName +
                                              ", ";
                                        } else if (i <
                                            snapshot2.data!.length - 1) {
                                          countryNames = countryNames +
                                              snapshot2.data!
                                                  .elementAt(i)
                                                  .countryName +
                                              " or ";
                                        } else {
                                          countryNames = countryNames +
                                              snapshot2.data!
                                                  .elementAt(i)
                                                  .countryName;
                                        }
                                      }
                                      return Text(snapshot1.data!.name +
                                          " maybe from " +
                                          countryNames);
                                    }
                                  } else if (snapshot2.connectionState ==
                                      ConnectionState.waiting) {
                                    debugPrint("Waiting for Country Name data");
                                    return const CircularProgressIndicator();
                                  } else {
                                    debugPrint("Got Nothing to Show 2");
                                    debugPrint("Snapshot state: " +
                                        snapshot2.connectionState.toString());
                                    return Container();
                                  }
                                });
                          }
                        } else if (snapshot1.connectionState ==
                            ConnectionState.waiting) {
                          debugPrint("Waiting for Country Id data");
                          return const CircularProgressIndicator();
                        } else {
                          debugPrint("Snapshot state: " +
                              snapshot1.connectionState.toString());
                          debugPrint("Got Nothing to show 1");
                          return Container();
                        }
                      },
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
