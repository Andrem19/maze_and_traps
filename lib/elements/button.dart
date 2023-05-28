import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';

class MenuButton {
  static const double shaddow = 0.5;
  static Widget getButton(String name, String path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: InkWell(
        onTap: () async {
          var AdCtr = Get.find<AdAndVisualController>();
          if (!AdCtr.buttonWasClick) {
          await AdCtr.pressMenuButtonEffects(path);
          }
        },
        child: Container(
          width: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/images/button.png',
                  height: Get.size.height / 20,
                  width: Get.size.width / 2,
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                    // fontFamily: 'ArchitectsDaughter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          // bottomLeft
                          offset: Offset(-shaddow, -shaddow),
                          color: Colors.white),
                      Shadow(
                          // bottomRight
                          offset: Offset(shaddow, -shaddow),
                          color: Colors.white),
                      Shadow(
                          // topRight
                          offset: Offset(shaddow, shaddow),
                          color: Colors.white),
                      Shadow(
                          // topLeft
                          offset: Offset(-shaddow, shaddow),
                          color: Colors.white),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
