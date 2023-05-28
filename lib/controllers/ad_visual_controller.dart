import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdAndVisualController extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  Rx<bool> showQR = false.obs;
  bool openDialog = false;

  bool buttonWasClick = false;
  RxDouble mainScreenShaddow = 0.0.obs;

  @override
  void onInit() async {
    await loadAudioAssets();
    super.onInit();
  }

  Future<void> pressMenuButtonEffects(String path) async {
    buttonWasClick = true;
    await FlameAudio.play('boom1.mp3');
    for (var i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      mainScreenShaddow.value += 0.1;
      update();
    }
    await Future.delayed(Duration(milliseconds: 60));
    for (var i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: 30));
      mainScreenShaddow.value -= 0.1;
      update();
    }
    if (mainScreenShaddow.value != 0.0) {
      mainScreenShaddow.value = 0.0;
    }
    update();
    Get.toNamed(path);
    buttonWasClick = false;
  }

  //// QR ////
  void changeQrShow() {
    showQR.value = !showQR.value;
    update();
  }

  QrImageView createQR() {
    return QrImageView(
      data: mainCtrl.userName.value,
      version: QrVersions.auto,
      size: 200.0,
    );
  }

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache.loadAll(['door-slide1.mp3', 'boom1.mp3']);
  }
}
