import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArrowDir {
  static Widget ArrowDirectionChange(
      bool up, bool down, bool left, bool right) {
    if (up) {
      return Image.asset(
        'assets/images/control/texture_SwipeUp.png',
        width: Get.size.height / 3,
      );
    } else if (down) {
      return Image.asset(
        'assets/images/control/texture_SwipeDown.png',
        width: Get.size.height / 3,
      );
    } else if (right) {
      return Image.asset(
        'assets/images/control/texture_SwipeRight.png',
        width: Get.size.height / 3,
      );
    } else if (left) {
      return Image.asset(
        'assets/images/control/texture_SwipeLeft.png',
        width: Get.size.height / 3,
      );
    }
    return SizedBox();
  }
}
