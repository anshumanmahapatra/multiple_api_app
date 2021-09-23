import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../models/gender_model.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(title: const Text('Gender Detector')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter a Name to detect the Gender'),
                  onSaved: (val) {
                    controller.saveGenderName(val!);
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
                  child: const Text("What's my Gender?"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      controller.getGender(controller.genderName.value);
                    }
                  },
                ),
                const SizedBox(height: 40),
                Obx(() {
                  return Offstage(
                    offstage: controller.genderName.value == "",
                    child: FutureBuilder<GenderModel>(
                      future: controller.genderData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            debugPrint(snapshot.error.toString());
                            debugPrint("Showing Empty Container");
                            return Container();
                          } else {
                            debugPrint("Got Data");
                            return Text(snapshot.data!.name +
                                " is a " +
                                snapshot.data!.gender.toString());
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          debugPrint("Waiting for data");
                          return const CircularProgressIndicator();
                        } else {
                          debugPrint("Snapshot state: " +
                              snapshot.connectionState.toString());
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
        ));
  }
}
