import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import '../services/editor_page.dart';
import '../services/map_operation.dart';
import 'main_game_controller.dart';

class MapTrainingActController extends GetxController {
  // late List<List<List<int>>> fogSet;
  int fogCounter = 0;
  late DateTime now;
  int shaddowRadius = 4;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  late Rx<GameInfo> gameInfo =
      GameInfo.createEmptyGameInfo(mainCtrl.currentGameMap!).obs;
  String mapId = '';
  int durationOfAct = 600;
  late int time;
  Duration clockTimer = Duration(seconds: 600);
  Rx<String> timerText = ''.obs;
  var _timer;
  Rx<String> _yourRole = 'A'.obs;
  String get yourRole => _yourRole.value;
  Rx<String> textMessage = ''.obs;

  Rx<bool> showSkills = false.obs;
  Rx<bool> _frozenActivate = false.obs;
  Rx<bool> _teleportDoor = false.obs;
  Rx<bool> _teleportExit = false.obs;
  bool get frozenActivate => _frozenActivate.value;
  bool get teleportDoor => _teleportDoor.value;
  bool get teleportExit => _teleportExit.value;

  Rx<Direction> moveDirection = Direction.up.obs;
  Rx<MazeMap> mazeMap =
      EditorPageMap.createStruct(TestData.createTestMap()).obs;

  @override
  void onInit() {
    Get.find<MainGameController>().changeStatusInGame(true);
    now = DateTime.now();
    // fogSet = TestData.calc5Fog();
    if (mainCtrl.currentGameMap != null) {
      mazeMap.value = mainCtrl.currentGameMap!;
    } else {
      mazeMap = EditorPageMap.createStruct(TestData.createTestMap()).obs;
    }

    mapId = mainCtrl.currentMapId;
    time = durationOfAct;
    runEngine();
    // FlameAudio.bgm.initialize();
    // FlameAudio.bgm.play('maze_general_theme.mp3');
    super.onInit();
  }

  @override
  void onClose() {
    Get.find<MainGameController>().changeStatusInGame(false);
    stopEngine();
    FlameAudio.bgm.stop();
    super.onClose();
  }

  void stopEngine() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void runEngine() async {
    mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      // if (fogCounter > 3) {
      //   fogCounter = 0;
      //   now = DateTime.now();
      // } else {
      //   fogCounter++;
      // }
      moveDirection.value = mainCtrl.moveDir;
      mazeMap.value.MovePlayer_A(moveDirection.value);
      gameInfo.value = mazeMap.value.getGameInfo();
      mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);
      time--;
      clockTimer = Duration(seconds: time);
      timerText.value =
          '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      textMessage.value = mazeMap.value.message_A;
      update();
      if (time < 1 || isPlayerWinn()) {
        FlameAudio.play('victory.wav');
        gameEnd();
      }
    });
  }

  bool isPlayerWinn() {
    if (mazeMap.value.Player_A_Coord == mazeMap.value.Player_B_Coord) {
      return true;
    } else {
      return false;
    }
  }

  void gameEnd() async {
    stopEngine();
    await countAndSaveStat();
    Get.back();
  }

  Future<void> countAndSaveStat() async {
    int seconds = durationOfAct - time;
    try {
      var cntr = Get.find<MainGameController>();
      var document =
          await FirebaseFirestore.instance.collection('maps').doc(mapId).get();
      if (document.exists) {
        var data = document.data()!['champions'] as Map<String, dynamic>;
        bool exist = data.containsKey(cntr.userName);
        if (exist) {
          if (data[cntr.userName] as int < seconds) {
            return;
          } else {
            await FirebaseFirestore.instance
                .collection('maps')
                .doc(mapId)
                .update({
              'champions.${cntr.userName}': seconds,
            });
          }
        } else {
          await FirebaseFirestore.instance
              .collection('maps')
              .doc(mapId)
              .update({
            'champions.${cntr.userName}': seconds,
          });
        }
      }
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
}
