import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_game_controller.dart';
import '../controllers/routing/app_pages.dart';

class AppBarWithScrolls {
  static AppBar getAppBar(String path, String name) {
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
      leading: IconButton(
        onPressed: () async {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Center(child: Text(name)),
    );
  }
}