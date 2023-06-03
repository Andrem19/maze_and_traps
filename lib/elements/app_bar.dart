import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/play_switcher.dart';

class AppBarElement {
  static AppBar getAppBar() {
    return AppBar(
      actions: [
        GetBuilder<MainGameController>(builder: (controller) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.BACKPACK);
                    },
                    child: Image.asset(
                      'assets/images/backpack.png',
                      height: Get.size.height / 25,
                    )),
              ),
              InkWell(
                  onTap: () {
                    Get.toNamed(Routes.SCROLL_LIST);
                  },
                  child: Image.asset(
                    'assets/images/scrolls.png',
                    height: Get.size.height / 25,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 15),
                child: Text(
                  controller.scrolls.value.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'score: ${controller.points.value ?? 0}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        }),
      ],
      title: GetBuilder<MainGameController>(builder: (controller) {
        return Text(controller.userName.value);
      }),
    );
  }
}
