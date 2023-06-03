import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';

class BattleActController extends GetxController {
  late Rx<MazeMap> mazeMap;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  Rx<String> gameId = ''.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  Rx<GameInfo> gameInfo = GameInfo.createEmptyGameInfo(
          Get.find<MainGameController>().currentGameMap!)
      .obs;

  Rx<bool> showSkills = false.obs;

  String yourRole = 'A';
  Rx<String> textMessage = ''.obs;
  Rx<Direction> moveDirection = Direction.up.obs;
  int shaddowRadius = 3;
  var _timer;

  @override
  void onInit() {
    mainCtrl.changeStatusInGame(true);
    super.onInit();
  }

  @override
  void onClose() {
    mainCtrl.changeStatusInGame(false);
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.onClose();
  }

  void countFinal(String vinner) async {
    FlameAudio.play('victory.wav');
    try {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'vinner': vinner,
      });
      listner.cancel();

      Get.offNamed(Routes.END_GAME_SCREEN);
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> PlayerNotReady() async {
    String vinner = '';
    var doc = await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .get();
    if (doc.exists) {
      var data = doc.data();
      String gameVinner = data!['vinner'];
      if (gameVinner != yourRole) {
        vinner = yourRole == 'A' ? 'B' : 'A';
      } else {
        vinner = yourRole;
      }
    }
    if (yourRole == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({'gameStatus': 'finish', 'Player_A_ready': false});
    } else {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({'gameStatus': 'finish', 'Player_B_ready': false});
    }
    mainCtrl.vinner = vinner;
  }

  Future<void> setUpVars() async {
    mazeMap = mainCtrl.currentGameMap!.obs;
    gameId.value = mainCtrl.currentmultiplayerGameId;
    yourRole = mainCtrl.YourCurrentRole;
    shaddowRadius = mainCtrl.globalSettings.default_shaddow_radius;
    if (yourRole == 'A') {
      mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);
      changeState(mazeMap.value.getGameInfo(), yourRole);
    } else {
      mazeMap.value.reversePlus();
      mazeMap.value.countRadiusAroundPlayer_B(shaddowRadius, true);
      changeState(
          GameInfo.reverseGameInfo(mazeMap.value.getGameInfo(), mazeMap.value),
          yourRole);
    }
    update();
  }
  void changeState(GameInfo gameInfo, String role) async {
    print(role);
    if (role == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_A': gameInfo.toJson(),
      });
    } else if (role == 'B') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_B': gameInfo.toJson(),
      });
    }
  }
}
