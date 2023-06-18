// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mazeandtraps/controllers/battle_act_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/models/maze_map.dart';

import '../models/trap.dart';
import '../services/generate_traps.dart';

class TrapsController extends GetxController {
  late BattleActController _battleActController;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController main = Get.find<MainGameController>();

  int playerFrozen = 0;
  int playerBlind = 0;
  int playerGhost = 0;
  bool frozenActivate = false;
  bool teleportActivate = false;
  bool bombActivate = false;
  bool knifesActivate = false;
  bool meteorActivate = false;
  bool blindnessActivate = false;
  bool poisonActivate = false;
  bool ghostActivate = false;
  int knifes = 2;
  int showTrapWhenCaught = 0;

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
    if (showTrapWhenCaught == 1) {
      _battleActController.mazeMap.value.mazeMap.forEach((element) {
        element.forEach((el) {
          el.additionalStuff = null;
        });
      });
      showTrapWhenCaught--;
    } else if (showTrapWhenCaught > 0) {
      showTrapWhenCaught--;
    }
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
      checkTrap('knifes', _battleActController.gameInfo.value.Knifes_B,
          knifesActivate, () async {
        await FlameAudio.play(TrapsGenerator.knife.audio);
      });
      checkTrap('meteor', _battleActController.gameInfo.value.Meteor_B,
          meteorActivate, () async {
        await FlameAudio.play(TrapsGenerator.meteor.audio);
      });
      checkTrap('blindness', _battleActController.gameInfo.value.Blindness_B,
          blindnessActivate, () async {
        await FlameAudio.play(TrapsGenerator.blindness.audio);
      });
      checkTrap('poison', _battleActController.gameInfo.value.Poison_B,
          poisonActivate, () async {
        await FlameAudio.play(TrapsGenerator.poison.audio);
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
      checkTrap('knifes', _battleActController.gameInfo.value.Knifes_A,
          knifesActivate, () async {
        await FlameAudio.play(TrapsGenerator.knife.audio);
      });
      checkTrap('meteor', _battleActController.gameInfo.value.Meteor_A,
          meteorActivate, () async {
        await FlameAudio.play(TrapsGenerator.meteor.audio);
      });
      checkTrap('blindness', _battleActController.gameInfo.value.Blindness_A,
          blindnessActivate, () async {
        await FlameAudio.play(TrapsGenerator.blindness.audio);
      });
      checkTrap('poison', _battleActController.gameInfo.value.Poison_A,
          poisonActivate, () async {
        await FlameAudio.play(TrapsGenerator.poison.audio);
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
          showTrapOnceWhenCaught(TrapsGenerator.frozen.img);
          IamCaught(1);
          callback();
        }
      }
    } else if (trapType == 'teleport') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          teleportActivate = true;
          showTrapOnceWhenCaught(TrapsGenerator.teleport.img);
          teleportAction();
          IamCaught(2);
          callback();
        }
      }
    } else if (trapType == 'bomb') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          bombActivate = true;
          showTrapOnceWhenCaught(TrapsGenerator.bomb.img);
          damage(TrapsGenerator.bomb.damage);
          IamCaught(3);
          callback();
        }
      }
    } else if (trapType == 'knifes') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          knifesActivate = true;
          showTrapOnceWhenCaught(TrapsGenerator.knife.img);
          damage(TrapsGenerator.knife.damage);
          IamCaught(4);
          callback();
        }
      }
    } else if (trapType == 'meteor') {
      if (trapLoc.isInit && !trapActivate) {
        meteorActivate = true;
        IamCaught(11);
        callback();
        showTrapOnceWhenCaught(TrapsGenerator.meteor.img_2);
        damage(TrapsGenerator.meteor.damage);
      }
    } else if (trapType == 'blindness') {
      if (trapLoc.isInit && !trapActivate) {
        blindnessActivate = true;
        playerBlind = 12;
        IamCaught(8);
        callback();
        showTrapOnceWhenCaught(TrapsGenerator.blindness.img);
      }
    } else if (trapType == 'poison') {
      if (trapLoc.isInit && !trapActivate) {
        if (playerLoc == trapLoc) {
          poisonActivate = true;
          poisonDamage(TrapsGenerator.poison.damage);
          IamCaught(9);
          callback();
          showTrapOnceWhenCaught(TrapsGenerator.poison.img);
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
        setTrapUsed(1);
        break;
      case 2:
        installTrap(
            2,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Teleport_A = position
                : _battleActController.gameInfo.value.Teleport_B = position);
        setTrapUsed(2);
        break;
      case 3:
        installTrap(
            3,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Bomb_A = position
                : _battleActController.gameInfo.value.Bomb_B = position);
        setTrapUsed(3);
        break;
      case 4:
        installTrap(
            4,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Knifes_A = position
                : _battleActController.gameInfo.value.Knifes_B = position);
        if (knifes == 1) {
          setTrapUsed(4);
        } else {
          knifes--;
        }
        break;
      case 5:
        useSpeed_1(5);
        setTrapUsed(5);
        break;
      case 6:
        useSpeed_2(6);
        setTrapUsed(6);
        break;
      case 7:
        goThroughTheWall(7);
        setTrapUsed(7);
        break;
      case 8:
        useBlindness(8);
        setTrapUsed(8);
        break;
      case 9:
        installTrap(
            9,
            (position) => _battleActController.yourRole == 'A'
                ? _battleActController.gameInfo.value.Poison_A = position
                : _battleActController.gameInfo.value.Poison_B = position);
        setTrapUsed(9);
        break;
      case 10:
        healeeng(10);
        setTrapUsed(10);
        break;
      case 11:
        useSingleMeteore(11);
        setTrapUsed(11);
        break;
      default:
    }
    main.update();
    if (trap.id != 5 && trap.id != 6) {
      await FlameAudio.play('sfx_TrapSet.mp3');
    }
  }

  void setTrapUsed(int id) {
    main.backpackSet.firstWhere((p0) => p0.id == id).used = true;
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
      row = rand.nextInt(_battleActController.mazeHight -
              _battleActController.mazeMap.value.Player_A_Coord.row +
              1) +
          _battleActController.mazeMap.value.Player_A_Coord.row -
          1;
    } else {
      row = rand.nextInt(_battleActController.mazeHight -
              _battleActController.mazeMap.value.Player_B_Coord.row +
              1) +
          _battleActController.mazeMap.value.Player_B_Coord.row -
          1;
    }
    col = rand.nextInt(_battleActController.mazeWidth);
    return Coordinates(isInit: true, row: row, col: col);
  }

  Coordinates generateRandomCoordforMeteor() {
    var rand = Random();
    int row = rand.nextInt(_battleActController.mazeHight);
    int col = rand.nextInt(_battleActController.mazeWidth);
    return Coordinates(isInit: true, row: row, col: col);
  }

  Coordinates randCoord() {
    Coordinates res = generateRandomCoord();
    if (_battleActController.mazeMap.value.mazeMap[res.row][res.col].wall) {
      randCoord();
    }
    return res;
  }

  Coordinates randCoordForMeteor() {
    Coordinates res = generateRandomCoordforMeteor();
    if (_battleActController.mazeMap.value.mazeMap[res.row][res.col].wall) {
      randCoordForMeteor();
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

  void IamCaught(int id) async {
    if (_battleActController.yourRole == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(_battleActController.gameId.value)
          .update({
        'Player_A_caught': id,
      });
    } else {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(_battleActController.gameId.value)
          .update({
        'Player_B_caught': id,
      });
    }
  }

  Widget returnMeteor() {
    return Image.asset(TrapsGenerator.bomb.img);
  }

  void generateMeteor() {
    int count =
        _battleActController.mazeHight * _battleActController.mazeWidth ~/ 4;
    for (var i = 0; i < count; i++) {
      var coord = randCoordForMeteor();
      _battleActController.mazeMap.value.mazeMap[coord.row][coord.col]
          .additionalStuff = returnMeteor;
    }
  }

  void showTrapOnceWhenCaught(String trapImg) {
    showTrapWhenCaught = 3;
    Coordinates coord = _battleActController.yourRole == 'A'
        ? _battleActController.mazeMap.value.Player_A_Coord
        : _battleActController.mazeMap.value.Player_B_Coord;
    _battleActController.mazeMap.value.mazeMap[coord.row][coord.col]
        .additionalStuff = () => Image.asset(trapImg);
  }

  void allAditionalStuffToNull() {
    _battleActController.mazeMap.value.mazeMap.forEach((element) {
      element.forEach((el) {
        el.additionalStuff = null;
      });
    });
  }

  void useSingleMeteore(int trapId) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      _battleActController.yourRole == 'A'
          ? _battleActController.gameInfo.value.Meteor_A.isInit = true
          : _battleActController.gameInfo.value.Meteor_B.isInit = true;
    }
  }

  void useBlindness(int trapId) {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      _battleActController.yourRole == 'A'
          ? _battleActController.gameInfo.value.Blindness_A.isInit = true
          : _battleActController.gameInfo.value.Blindness_B.isInit = true;
    }
  }

  void useSpeed_1(int trapId) async {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      _battleActController.changeStreamInterval(TrapsGenerator.speed15.baff);
      await FlameAudio.play(TrapsGenerator.speed15.audio);
    }
  }

  void useSpeed_2(int trapId) async {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      _battleActController.changeStreamInterval(TrapsGenerator.speed2.baff);
      await FlameAudio.play(TrapsGenerator.speed2.audio);
    }
  }

  void goThroughTheWall(int trapId) async {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      playerGhost = 3;
      await FlameAudio.play(TrapsGenerator.ghost.audio);
    }
  }

  void poisonDamage(int dam) async {
    int count = dam;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      damage(1);
      count--;

      if (count <= 0) {
        timer.cancel();
      }
    });
  }

  void healeeng(int trapId) async {
    if (main.backpackSet.any((obj) => obj.id == trapId)) {
      main.YourCurrentRole == 'A'
          ? main.player_A_Life.value += TrapsGenerator.healing.baff
          : main.player_B_Life.value += TrapsGenerator.healing.baff;
      int life = _battleActController.yourRole == 'A'
          ? main.player_A_Life.value.toInt()
          : main.player_B_Life.value.toInt();
      changeLifeOnServer(
          _battleActController.yourRole, life);
      await FlameAudio.play(TrapsGenerator.healing.audio);
    }
  }
}
