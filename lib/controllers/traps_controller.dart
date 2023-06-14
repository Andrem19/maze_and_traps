// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController main = Get.find<MainGameController>();

  int playerFrozen = 0;
  bool frozenActivate = false;
  bool teleportActivate = false;

  @override
  void onInit() {
    loadAudioAssets();
    allTrapsToNotUsed();
    super.onInit();
  }

  @override
  void onClose() {
    // deleteFromCache();
    super.onClose();
  }

  void initialize(BattleActController battleActController) {
    _battleActController = battleActController;
  }

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache
        .loadAll(['sfx_FrostTrap.mp3', 'sfx_teleport.mp3']);
  }

  //Frozen

  void frozenInstall(int trapId) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      if (_battleActController.yourRole == 'A') {
        _battleActController.gameInfo.value.Frozen_trap_A = Coordinates(
            isInit: true,
            row: _battleActController.mazeMap.value.Player_A_Coord.row,
            col: _battleActController.mazeMap.value.Player_A_Coord.col);
      } else {
        _battleActController.gameInfo.value.Frozen_trap_B = swapCoordinates(
            Coordinates(
                isInit: true,
                row: _battleActController.mazeMap.value.Player_B_Coord.row,
                col: _battleActController.mazeMap.value.Player_B_Coord.col),
            _battleActController.mazeWidth,
            _battleActController.mazeHight);
      }
    }
  }

  Future<void> checkAllTraps() async {
    frozenCheck();
    teleportCheck();
  }

  void frozenCheck() async {
    if (_battleActController.yourRole == 'A') {
      if (_battleActController.gameInfo.value.Frozen_trap_B.isInit &&
          frozenActivate == false) {
        if (_battleActController.mazeMap.value.Player_A_Coord ==
            _battleActController.gameInfo.value.Frozen_trap_B) {
          frozenActivate = true;
          playerFrozen = 8;
          IamCaught();
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
          IamCaught();
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
  //Teleport

  void installTeleport(int trapId) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      if (_battleActController.yourRole == 'A') {
        _battleActController.gameInfo.value.Teleport_A = Coordinates(
            isInit: true,
            row: _battleActController.mazeMap.value.Player_A_Coord.row,
            col: _battleActController.mazeMap.value.Player_A_Coord.col);
      } else {
        _battleActController.gameInfo.value.Teleport_B = swapCoordinates(
            Coordinates(
                isInit: true,
                row: _battleActController.mazeMap.value.Player_B_Coord.row,
                col: _battleActController.mazeMap.value.Player_B_Coord.col),
            _battleActController.mazeWidth,
            _battleActController.mazeHight);
      }
    }
  }

  void teleportCheck() async {
    if (_battleActController.yourRole == 'A') {
      if (_battleActController.gameInfo.value.Teleport_B.isInit &&
          teleportActivate == false) {
        if (_battleActController.mazeMap.value.Player_A_Coord ==
            _battleActController.gameInfo.value.Teleport_B) {
          teleportActivate = true;
          teleportAction();
          await FlameAudio.play('sfx_teleport.mp3');
        }
      }
    } else {
      if (_battleActController.gameInfo.value.Teleport_A.isInit &&
          teleportActivate == false) {
        if (_battleActController.mazeMap.value.Player_B_Coord ==
            _battleActController.gameInfo.value.Teleport_A) {
          teleportActivate = true;
          teleportAction();
          await FlameAudio.play('sfx_teleport.mp3');
        }
      }
    }
  }

  void teleportAction() async {
    if (_battleActController.yourRole == 'A') {
      _battleActController.mazeMap.value.Player_A_Coord = randCoord();
    } else {
      _battleActController.mazeMap.value.Player_B_Coord = randCoord();
    }
    IamCaught();
    await FlameAudio.play('sfx_teleport.mp3');
  }

  void traps(Trap trap) async {
    switch (trap.id) {
      case 1:
        frozenInstall(1);
        break;
      case 2:
        installTeleport(2);
        break;
      default:
    }
    await FlameAudio.play('sfx_TrapSet.mp3');
  }

  void allTrapsToNotUsed() {
    main.backpackSet.forEach((element) {
      element.used = false;
    });
  }

  void damage(int damage) {
    if (main.YourCurrentRole == 'A') {
      main.player_A_Life.value -= damage;
      if (main.player_A_Life.value < 0) {
        main.player_A_Life.value = 0;
      }
      changeLifeOnServer(
          _battleActController.yourRole, main.player_A_Life.value.toInt());
    } else {
      main.player_B_Life.value -= damage;
      if (main.player_B_Life.value < 0) {
        main.player_B_Life.value = 0;
      }
      changeLifeOnServer(
          _battleActController.yourRole, main.player_B_Life.value.toInt());
    }
  }

  void changeLifeOnServer(String role, int amount) async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(_battleActController.gameId.value)
        .update({
      'Player_${role}_Life': amount,
    });
  }

  Coordinates generateRandomCoord() {
    var rand = Random();
    int row = 0;
    int col = 0;
    if (_battleActController.yourRole == 'A') {
      row = rand.nextInt(_battleActController.mazeHight -
          _battleActController.mazeMap.value.Player_A_Coord.row);
    } else {
      row = rand.nextInt(_battleActController.mazeHight -
          _battleActController.mazeMap.value.Player_B_Coord.row);
    }
    col = rand.nextInt(_battleActController.mazeWidth);
    return Coordinates(isInit: true, row: row, col: col);
  }

  Coordinates randCoord() {
    Coordinates res = generateRandomCoord();
    if (_battleActController.mazeMap.value.mazeMap[res.row][res.col].wall) {
      randCoord();
    }
    return res;
  }

  Coordinates swapCoordinates(Coordinates Player_Coord, int width, int hight) {
    var Player_L_Coord = Coordinates(
        isInit: Player_Coord.isInit,
        row: (width - 1) - Player_Coord.row,
        col: (hight - 1) - Player_Coord.col);
    return Player_L_Coord;
  }

  void IamCaught() async {
    if (_battleActController.yourRole == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(_battleActController.gameId.value)
          .update({
        'Player_A_caught': true,
      });
    } else {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(_battleActController.gameId.value)
          .update({
        'Player_B_caught': true,
      });
    }
  }
}
