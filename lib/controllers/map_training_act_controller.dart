import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import '../services/editor_page.dart';
import '../services/map_operation.dart';
import 'main_game_controller.dart';

class MapTrainingActController extends GetxController {
  int timerDuration = 1200;
  int shaddowRadius = 3;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  Rx<GameInfo> gameInfo = GameInfo.createEmptyGameInfo(
          Get.find<MainGameController>().currentGameMap!)
      .obs;
  String mapId = '';
  int durationOfAct = 600;

  late int time;
  Duration clockTimer = Duration(seconds: 600);
  Rx<String> timerText = ''.obs;
  Timer? _timer;

  Rx<String> yourRole = 'A'.obs;
  Rx<String> textMessage = ''.obs;

  Rx<bool> showSkills = false.obs;
  Rx<bool> frozenActivate = false.obs;
  Rx<bool> teleportDoor = false.obs;
  Rx<bool> teleportExit = false.obs;

  bool get frozenActivateValue => frozenActivate.value;
  bool get teleportDoorValue => teleportDoor.value;
  bool get teleportExitValue => teleportExit.value;

  RxBool up = false.obs;
  RxBool down = false.obs;
  RxBool left = false.obs;
  RxBool right = false.obs;

  Rx<Direction> moveDirection = Direction.up.obs;
  Rx<MazeMap> mazeMap =
      EditorPageMap.createStruct(TestData.createTestMap()).obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    mazeMap = EditorPageMap.createStruct(TestData.createTestMap()).obs;
    gameInfo = GameInfo.createEmptyGameInfo(mainCtrl.currentGameMap!).obs;
    gameInfo.value.myRole = 'A';

    mainCtrl.changeStatusInGame(true);
    await setSettings();

    if (mainCtrl.currentGameMap != null) {
      mazeMap.value = mainCtrl.currentGameMap!;
    }

    mapId = mainCtrl.currentMapId;
    time = durationOfAct;
    mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);

    _timer =
        Timer.periodic(Duration(milliseconds: timerDuration), (timer) async {
      await timerCode();
    });
  }

  @override
  void onClose() {
    stopEngine();
    mainCtrl.changeStatusInGame(false);
    super.onClose();
  }

  void stopEngine() {
    _timer?.cancel();
  }

  Future<void> timerCode() async {
    moveDirection.value = mainCtrl.moveDir;
    mazeMap.value.MovePlayer_A(moveDirection.value, gameInfo.value);

    double distance = mazeMap.value.calculateDistance();
    distance = double.parse(distance.toStringAsFixed(2));

    textMessage.value = 'Distance: $distance';
    mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);

    time--;
    clockTimer = Duration(seconds: time);
    timerText.value =
        '${clockTimer.inMinutes.remainder(60)}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    update();

    if (time < 1 || isPlayerWinn()) {
      FlameAudio.play('victory.wav');
      await gameEnd();
    }
  }

  void changeTimerDuration() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: timerDuration), (timer) async {
      await timerCode();
    });
  }

  bool isPlayerWinn() =>
      mazeMap.value.Player_A_Coord == mazeMap.value.Player_B_Coord;

  Future<void> gameEnd() async {
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

  void allDirFalse() {
    right.value = false;
    left.value = false;
    up.value = false;
    down.value = false;
    update();
  }

  Future<void> setSettings() async {
    timerDuration = mainCtrl.globalSettings.speed_1;
    mainCtrl.player_A_Life.value =
        mainCtrl.globalSettings.default_health.toDouble();
    mainCtrl.player_B_Life.value =
        mainCtrl.globalSettings.default_health.toDouble();
    shaddowRadius = mainCtrl.globalSettings.default_shaddow_radius;
    durationOfAct = mainCtrl.globalSettings.timer_back_for_training;
  }
}
