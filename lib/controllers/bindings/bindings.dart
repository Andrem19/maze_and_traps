
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/settings_controller.dart';

import '../ad_visual_controller.dart';
import '../main_game_controller.dart';
import '../map_editor_controller.dart';
import '../qr_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainGameController(), permanent: true);
    Get.put(AdAndVisualController(), permanent: true);
  }
}
class QrControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrController(), permanent: false);
  }
}
class MapEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapEditorController(), permanent: false);
  }
}
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController(), permanent: false);
  }
}