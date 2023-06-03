import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

class BattleActController extends GetxController {
  String id = '';
  @override
  void onInit() {
    id = Get.find<MainGameController>().currentmultiplayerGameId;
    print(id);
    super.onInit();
  }
}
