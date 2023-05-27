
import 'package:get/get.dart';

import '../ad_controller.dart';
import '../main_game_controller.dart';
import '../qr_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainGameController(), permanent: true);
    Get.put(AdController(), permanent: true);
  }
}
class QrControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrController(), permanent: false);
  }
}