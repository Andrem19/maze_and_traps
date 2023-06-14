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
import '../services/generate_traps.dart';

class TrapsController extends GetxController {
  late BattleActController _battleActController;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController main = Get.find<MainGameController>();

  int playerFrozen = 0;
  bool frozenActivate = false;
  bool teleportActivate = false;
  bool bombActivate = false;
  bool knifesActivate = false;

  @override
  void onInit() {
    loadAudioAssets();
    allTrapsToNotUsed();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initialize(BattleActController battleActController) {
    _battleActController = battleActController;
  }

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache.loadAll(getAudioSet());
  }

  List<String> getAudioSet() {
    List<String> audioSet = [];
    main.backpackSet.forEach((element) {
      if (element.audio != '') {
        audioSet.add(element.audio);
      }
    });
    return audioSet;
  }

  void installTrap(int trapId, Function(Coordinates) trapPositionSetter) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      final playerCoord = _battleActController.yourRole == 'A'
          ? _battleActController.mazeMap.value.Player_A_Coord
          : swapCoordinates(_battleActController.mazeMap.value.Player_B_Coord,
              _battleActController.mazeWidth, _battleActController.mazeHight);
      ;
      trapPositionSetter(Coordinates(
        isInit: true,
        row: playerCoord.row,
        col: playerCoord.col,
      ));
    }
  }

  Future<void> checkAllTraps() async {
    if (_battleActController.yourRole == 'A') {
      checkTrap('frozen', _battleActController.gameInfo.value.Frozen_trap_B,
          frozenActivate, () async {
        await FlameAudio.play(TrapsGenerator.frozen.audio);
      });
      checkTrap('teleport', _battleActController.gameInfo.value.Teleport_B,
          teleportActivate, () async {
        await FlameAudio.play(TrapsGenerator.teleport.audio);
      });
      checkTrap(
          'bomb', _battleActController.gameInfo.value.Bomb_B, bombActivate,
          () async {
        await FlameAudio.play(TrapsGenerator.bomb.audio);
      });
      checkTrap(
          'knifes', _battleActController.gameInfo.value.Knifes_B, knifesActivate,
          () async {
        await FlameAudio.play(TrapsGenerator.knife.audio);
      });
    } else {
      checkTrap('frozen', _battleActController.gameInfo.value.Frozen_trap_A,
          frozenActivate, () async {
        await FlameAudio.play(TrapsGenerator.frozen.audio);
      });
      checkTrap('teleport', _battleActController.gameInfo.value.Teleport_A,
          teleportActivate, () async {
        await FlameAudio.play(TrapsGenerator.teleport.audio);
      });
      checkTrap(
          'bomb', _battleActController.gameInfo.value.Bomb_A, bombActivate,
          () async {
        await FlameAudio.play(TrapsGenerator.bomb.audio);
      });
      checkTrap(
          'knifes', _battleActController.gameInfo.value.Knifes_A, knifesActivate,
          () async {
        await FlameAudio.play(TrapsGenerator.knife.audio);
      });
    }
  }

  void checkTrap(String trapType, Coordinates trapLoc, bool trapActivate,
      Function callback) {
    Coordinates playerLoc = _battleActController.yourRole == 'A'
        ? _battleActController.mazeMap.value.Player_A_Coord
        : _battleActController.mazeMap.value.Player_B_Coord;
    if (trapType == 'frozen') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          frozenActivate = true;
          playerFrozen = 8;
          IamCaught();
          callback();
        }
      }
    } else if (trapType == 'teleport') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          teleportActivate = true;
          teleportAction();
          IamCaught();
          callback();
        }
      }
    } else if (trapType == 'bomb') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          bombActivate = true;
          damage(TrapsGenerator.bomb.damage);
          IamCaught();
          callback();
        }
      }
    } else if (trapType == 'knifes') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          knifesActivate = true;
          damage(TrapsGenerator.knife.damage);
          IamCaught();
          callback();
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

  void teleportAction() async {
    print('teleport action');
    if (_battleActController.yourRole == 'A') {
      _battleActController.mazeMap.value.Player_A_Coord = randCoord();
    } else {
      _battleActController.mazeMap.value.Player_B_Coord = randCoord();
    }
  }

  void traps(Trap trap) async {
    switch (trap.id) {
      case 1:
        installTrap(
            1,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Frozen_trap_A = position
                : _battleActController.gameInfo.value.Frozen_trap_B = position);
        break;
      case 2:
        installTrap(
            2,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Teleport_A = position
                : _battleActController.gameInfo.value.Teleport_B = position);
        break;
      case 3:
        installTrap(
            3,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Bomb_A = position
                : _battleActController.gameInfo.value.Bomb_B = position);
        break;
      case 4:
        installTrap(
            4,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Knifes_A = position
                : _battleActController.gameInfo.value.Knifes_B = position);
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
    main.update();
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
      row = rand.nextInt(_battleActController.mazeMap.value.Player_A_Coord.row);
    } else {
      row = rand.nextInt(_battleActController.mazeMap.value.Player_B_Coord.row);
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
        row: (hight - 1) - Player_Coord.row,
        col: (width - 1) - Player_Coord.col);
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
