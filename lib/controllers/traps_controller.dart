// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';

import 'package:mazeandtraps/controllers/battle_act_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/models/game_info.dart';
import 'package:mazeandtraps/models/maze_map.dart';
import 'package:mazeandtraps/services/compare_coord.dart';

import '../models/trap.dart';

class TrapsController extends GetxController {
  late BattleActController _battleActController;
  MainGameController main = Get.find<MainGameController>();

  int playerFrozen = 0;
  bool frozenActivate = false;

  @override
  void onInit() {
    loadAudioAssets();
    super.onInit();
  }

  @override
  void onClose() {
    deleteFromCache();
    super.onClose();
  }

  void initialize(BattleActController battleActController) {
    _battleActController = battleActController;
  }

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache.loadAll(['sfx_FrostTrap.mp3']);
  }

  void deleteFromCache() async {
    await FlameAudio.audioCache.clear('sfx_FrostTrap.mp3');
  }

  void frozenInstall(int trapId) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      if (_battleActController.yourRole == 'A') {
        _battleActController.gameInfo.value.Frozen_trap_A = Coordinates(
            isInit: true,
            row: _battleActController.mazeMap.value.Player_A_Coord.row,
            col: _battleActController.mazeMap.value.Player_A_Coord.col);
      } else {
        _battleActController.gameInfo.value.Frozen_trap_B = Coordinates(
            isInit: true,
            row: _battleActController.mazeMap.value.Player_B_Coord.row,
            col: _battleActController.mazeMap.value.Player_B_Coord.col);
      }
    }
  }

  Future<void> checkAllTraps() async {
    frozenCheck();
  }

  void frozenCheck() async {
    if (_battleActController.yourRole == 'A') {
      if (_battleActController.gameInfo.value.Frozen_trap_B.isInit &&
          frozenActivate == false) {
        if (_battleActController.mazeMap.value.Player_A_Coord ==
            _battleActController.gameInfo.value.Frozen_trap_B) {
          frozenActivate = true;
          playerFrozen = 8;
          await FlameAudio.play('sfx_FrostTrap.mp3');
        }
      }
    } else {
      if (_battleActController.gameInfo.value.Frozen_trap_A.isInit &&
          frozenActivate == false) {
        if (_battleActController.mazeMap.value.Player_B_Coord ==
            _battleActController.gameInfo.value.Frozen_trap_A) {
          frozenActivate = true;
          playerFrozen = 8;
          await FlameAudio.play('sfx_FrostTrap.mp3');
        }
      }
    }
  }

  bool frozenDeactivation() {
    if (playerFrozen > 0) {
      playerFrozen--;
    }
    if (playerFrozen == 0) {
      frozenActivate = false;
    }
    return playerFrozen > 0 ? true : false;
  }

  void traps(Trap trap) async {
    switch (trap.id) {
      case 1:
        frozenInstall(1);
        break;
      default:
    }
    await FlameAudio.play('sfx_TrapSet.mp3');
  }
}
