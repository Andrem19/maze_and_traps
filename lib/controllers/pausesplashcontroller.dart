import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';

class PauseSplashController extends GetxController {
  RxBool isShow = true.obs;
  var _timer;
  RxString text = 'Tap Anywhere To Continue'.obs;

  @override
  void onInit() async {
    runClue();
    super.onInit();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.onClose();
  }

  void runClue() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      isShow.value = !isShow.value;
      update();
    });
  }

  Future<void> playDoor() async {
    await FlameAudio.play('door-slide1.mp3');
    await Future.delayed(Duration(milliseconds: 1300));
    Get.offNamed(Routes.GENERAL_MENU);
  }
}
