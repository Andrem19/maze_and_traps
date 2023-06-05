import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/battle_act_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

class TrapsLogic {
  final MainGameController main = Get.find<MainGameController>();
  final BattleActController game = Get.find<BattleActController>();
  static void trapsGeneralLogic(String role, String trap) {
    switch (trap) {
      case 'frozen':
        
        break;
      default:
    }
  }
}
