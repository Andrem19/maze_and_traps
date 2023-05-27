import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainGameController extends GetxController {
  RxString userName = 'Name'.obs;
  RxString score = ''.obs;
  Rx<bool> showQR = false.obs;
  TextEditingController playerSearch = TextEditingController(text: '');
  TextEditingController targetQrCode = TextEditingController();

  void changeQrShow() {
    showQR.value = !showQR.value;
    update();
  }

  QrImageView createQR() {
    return QrImageView(
      data: userName.value,
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
