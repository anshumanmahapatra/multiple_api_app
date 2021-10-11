import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/controller.dart';

import '../widgets/text_widget.dart';

class LoadingWidget {
  Controller controller = Get.put(Controller());
  TextWidget textWidget = Get.put(TextWidget());
  Widget getLoadingWidget() {
    double w = Get.mediaQuery.size.width;
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 30,
                width: w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              Positioned(
                left: 2,
                top: 2,
                child: TweenAnimationBuilder(
                    tween: Tween<double>(
                        begin: controller.beginWidth.value,
                        end: controller.endWidth.value),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, double width, _) {
                      return Container(
                        width: width,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                      );
                    }),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedList(
            key: controller.listKey,
            initialItemCount: controller.listOfLoadingText.length,
            shrinkWrap: true,
            itemBuilder: (context, index, animation) {
              return SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: animation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget.getGenderTextWidget(
                              controller.listOfLoadingText[index]),
                          const SizedBox(width: 5),
                          controller.listOfLoadingText[index].substring(0, 3) ==
                                  "Got"
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Offstage(
                                    offstage: controller.listOfShouldShowLottie[index],
                                    child: Lottie.asset(
                                      "assets/lottie/check_mark.json",
                                      repeat: false,
                                      height: 30,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
