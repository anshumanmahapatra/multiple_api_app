import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_api_app/models/age_model.dart';
import '../controller/controller.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(title: const Text('Age Detector')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter a Name to detect the Age'),
                  onSaved: (val) {
                    controller.saveAgeName(val!);
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
                  child: const Text("What's my Age?"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      controller.getAge(controller.ageName.value);
                    }
                  },
                ),
                const SizedBox(height: 40),
                Obx(() {
                  return Offstage(
                    offstage: controller.ageName.value == "",
                    child: FutureBuilder<AgeModel>(
                      future: controller.ageData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            debugPrint(snapshot.error.toString());
                            return const Text(
                                "Sorry we could not process your input");
                          } else {
                            debugPrint("Got Data");
                            return Text(snapshot.data!.name +
                                " is of age " +
                                snapshot.data!.age.toString());
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
