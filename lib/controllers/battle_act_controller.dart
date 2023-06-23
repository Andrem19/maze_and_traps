import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/traps_controller.dart';
import 'package:mazeandtraps/models/gameInfoCloud.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';

class BattleActController extends GetxController {
  late String textOfMazeScroll = '';
  late int mazeWidth;
  late int mazeHight;
  late Rx<MazeMap> mazeMap;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;
  Rx<String> gameId = ''.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MainGameController mainCtrl = Get.find<MainGameController>();
  late TrapsController _trapsController;
  Rx<GameInfo> gameInfo = GameInfo.createEmptyGameInfo(
          Get.find<MainGameController>().currentGameMap!)
      .obs;
  var movePlayerA;
  var countRadiusAroundPlayerA;
  var movePlayerB;
  var countRadiusAroundPlayerB;
  var checkTheFinishA;
  var checkTheFinishB;
  Rx<bool> showSkills = false.obs;

  int time = 240;
  Duration clockTimer = Duration(seconds: 240);
  Rx<String> timerText = ''.obs;

  String gameStatus = '';
  bool showArrowController = false;
  String scrollOwner = 'none';
  String yourRole = 'A';
  Rx<String> textMessage = ''.obs;
  int messageCounter = 0;
  Rx<Direction> moveDirection = Direction.up.obs;
  int shaddowRadius = 3;
  int timerDuration = 1200;
  int A_Caught_Old = 0;
  int B_Caught_Old = 0;
  var _stream;
  var oldSubscription;

  RxBool up = false.obs;
  RxBool down = false.obs;
  RxBool left = false.obs;
  RxBool right = false.obs;

  @override
  void onInit() async {
    mainCtrl.changeStatusInGame(true);
    gameEngine();
    super.onInit();
  }

  @override
  void onClose() async {
    await playerNotReady();
    rewardCount(scrollOwner);
    mainCtrl.deleteGameInstant();
    mainCtrl.changeStatusInGame(false);
    oldSubscription?.cancel();
    _stream?.cancel();
    listner.cancel();
    super.onClose();
  }

  void initialize(TrapsController trapsController) {
    _trapsController = trapsController;
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
      Get.offNamed(Routes.END_GAME_SCREEN);
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(error.code),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> playerNotReady() async {
    String vinner = '';
    String enemy_role = yourRole == 'A' ? 'B' : 'A';
    try {
      var doc = await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .get();
      if (doc.exists) {
        var data = doc.data();
        String gameVinner = data!['vinner'];
        if (gameVinner == yourRole) {
          vinner = yourRole;
          await firebaseFirestore
              .collection('users')
              .doc(mainCtrl.userUid)
              .update({
            'points': mainCtrl.points.value + 2,
          });
          mainCtrl.points += 2;
        } else if (gameVinner == enemy_role) {
          vinner = enemy_role;
          await firebaseFirestore
              .collection('users')
              .doc(mainCtrl.userUid)
              .update({
            'points': mainCtrl.points.value - 1,
          });
          mainCtrl.points -= 1;
        } else if (gameVinner != yourRole && gameVinner != enemy_role) {
          vinner = enemy_role;
          await firebaseFirestore
              .collection('users')
              .doc(mainCtrl.userUid)
              .update({
            'points': mainCtrl.points.value - 1,
          });
          mainCtrl.points -= 1;
        }
      }
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'gameStatus': 'finish',
        'vinner': vinner,
        'Player_${yourRole}_ready': false,
      });
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
    mainCtrl.vinner.value = vinner;
    mainCtrl.update();
  }

  Future<void> setUpVars() async {
    late TrapsController trapsController;
    mazeMap = mainCtrl.YourCurrentRole == 'B'
        ? mainCtrl.currentGameMap!.reversePlus().obs
        : mainCtrl.currentGameMap!.obs;
    gameId.value = mainCtrl.currentmultiplayerGameId;
    yourRole = mainCtrl.YourCurrentRole.value;
    mazeHight = mazeMap.value.mazeMap.length;
    mazeWidth = mazeMap.value.mazeMap[0].length;
    showArrowController = mainCtrl.personalSettings.showArrowControl;
    shaddowRadius = mainCtrl.globalSettings.default_shaddow_radius;
    timerDuration = mainCtrl.globalSettings.speed_1;
    countRadiusAroundPlayerA = mazeMap.value.countRadiusAroundPlayer_A;
    countRadiusAroundPlayerB = mazeMap.value.countRadiusAroundPlayer_B;
    checkTheFinishA = mazeMap.value.checkTheFinish_A;
    checkTheFinishB = mazeMap.value.checkTheFinish_B;
    mainCtrl.player_A_Life.value =
        mainCtrl.globalSettings.default_health.toDouble();
    mainCtrl.player_B_Life.value =
        mainCtrl.globalSettings.default_health.toDouble();
    clockTimer = Duration(seconds: mainCtrl.globalSettings.timer);
    time = mainCtrl.globalSettings.timer;
    timerText.value = '${clockTimer.inMinutes.remainder(60)}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    if (yourRole == 'A') {
      mazeMap.value.countRadiusAroundPlayer_A(shaddowRadius, true);
      changeState(mazeMap.value.Player_A_Coord, gameInfo.value, yourRole);
    } else {
      mazeMap.value.countRadiusAroundPlayer_B(shaddowRadius, true);
      changeState(
        swapCoordinates(mazeMap.value.Player_B_Coord, mazeWidth, mazeHight),
        GameInfo.reverseGameInfo(gameInfo.value, mazeMap.value),
        yourRole,
      );
    }
    update();
    textOfMazeScroll = await getScroll();
  }

  void rewardCount(String scrollOwner) async {
    if (yourRole != scrollOwner) {
      return;
    }
    mainCtrl.scrollsList.add(textOfMazeScroll);
    mainCtrl.scrolls.value = mainCtrl.scrollsList.length;
    mainCtrl.update();
    await firebaseFirestore.collection('users').doc(mainCtrl.userUid).update({
      'scrolls': mainCtrl.scrollsList,
    });
  }

  Future<String> getScroll() async {
    var doc = await firebaseFirestore
        .collection('wisdomScrolls')
        .doc('TO3pay0R0byjSLMinIXq')
        .get();
    var data = doc.data();
    List<dynamic> scrollsCollection = data!['listOfScrolls'];
    return scrollsCollection[Random().nextInt(scrollsCollection.length)];
  }

  void gameEngine() async {
    await setUpVars();
    userControl();
    snapshots = FirebaseFirestore.instance
        .collection('gameBattle')
        .doc(gameId.value)
        .snapshots();

    listner = snapshots.listen(
      (data) {
        if (yourRole == 'A') {
          final gameInfoB = data['GameInfo_B'];
          final playerBCoord = data['Player_B_Coord'];
          scrollOwner = data['scrollOwner'];
          mainCtrl.enemyLife.value = data['Player_B_Life'];
          int B_Caught_New = data['Player_B_caught'];
          updateCoordinates(gameInfoB, playerBCoord, scrollOwner, yourRole);
          final gameStatus = data['gameStatus'];
          if (B_Caught_New != B_Caught_Old && B_Caught_New != 0) {
            B_Caught_Old = B_Caught_New;
            changeInit(B_Caught_New, yourRole);
            textMessage.value = setUpMessageAfterTrap(B_Caught_New);
          }
          if (gameStatus == 'finish') {
            finish_game(yourRole);
          }
        } else if (yourRole == 'B') {
          final gameInfoA = data['GameInfo_A'];
          final playerACoord = data['Player_A_Coord'];
          scrollOwner = data['scrollOwner'];
          mainCtrl.enemyLife.value = data['Player_A_Life'];
          int A_Caught_New = data['Player_A_caught'];
          updateCoordinates(gameInfoA, playerACoord, scrollOwner, yourRole);
          gameStatus = data['gameStatus'];
          if (A_Caught_New != A_Caught_Old && A_Caught_New != 0) {
            A_Caught_Old = A_Caught_New;
            changeInit(A_Caught_New, yourRole);
            textMessage.value = setUpMessageAfterTrap(A_Caught_New);
          }
          if (gameStatus == 'finish') {
            finish_game(yourRole);
          }
        }
        update();
      },
      onError: (error) {
        print(error);
      },
    );
  }

  void userControl() {
    _stream = Stream.periodic(
            Duration(milliseconds: timerDuration), (_) => updateUI())
        .listen((event) {
      update();
    });
  }

  void setUpMessage(int time, String text) {
    messageCounter = time;
    textMessage.value = text;
  }

  updateUI() {
    if (messageCounter > 0) {
      messageCounter--;
    } else {
      textMessage.value = '';
    }
    moveDirection.value = mainCtrl.moveDir;
    _trapsController.checkAllTraps();
    if (yourRole == 'A') {
      MovePlayer(moveDirection.value);
      if (_trapsController.playerBlind <= 0) {
        countRadiusAroundPlayerA(shaddowRadius, true);
      } else {
        _trapsController.playerBlind--;
        mazeMap.value.mazeMap
            .forEach((row) => row.forEach((node) => node.isShaddow = true));
      }

      final res = checkTheFinishA();
      if (res || mainCtrl.enemyLife <= 0 || (scrollOwner == 'A' && time <= 1)) {
        countFinal('A');
        mainCtrl.vinner.value = 'A';
      }
    } else if (yourRole == 'B') {
      MovePlayer(moveDirection.value);
      if (_trapsController.playerBlind <= 0) {
        countRadiusAroundPlayerB(shaddowRadius, true);
      } else {
        _trapsController.playerBlind--;
        mazeMap.value.mazeMap
            .forEach((row) => row.forEach((node) => node.isShaddow = true));
      }

      final res = checkTheFinishB();
      if (res || mainCtrl.enemyLife <= 0 || (scrollOwner == 'B' && time <= 1)) {
        countFinal('B');
        mainCtrl.vinner.value = 'B';
      }
    }
    if (scrollOwner == 'none') {
      checkAndTakeScroll();
    }
    changeState(
        yourRole == 'A'
            ? mazeMap.value.Player_A_Coord
            : swapCoordinates(
                mazeMap.value.Player_B_Coord, mazeWidth, mazeHight),
        yourRole == 'A'
            ? gameInfo.value
            : GameInfo.reverseGameInfo(gameInfo.value, mazeMap.value),
        yourRole);
    time--;
    clockTimer = Duration(seconds: time);
    timerText.value =
        '${clockTimer.inMinutes.remainder(60)}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void changeStreamInterval(int newInterval) {
    oldSubscription = _stream;

    _stream =
        Stream.periodic(Duration(milliseconds: newInterval), (_) => updateUI())
            .listen((event) {
      update();
    });
    // cancel the previous subscription to _stream
    oldSubscription.cancel();
  }

  void checkAndTakeScroll() async {
    if (yourRole == 'A') {
      if (mazeMap.value.Player_A_Coord.row == 17 &&
          mazeMap.value.Player_A_Coord.col == 10) {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(gameId.value)
            .update({
          'scrollOwner': 'A',
        });
        await FlameAudio.play('sfx_scroll.mp3');
        setUpMessage(4, textOfMazeScroll);
      }
    } else if (yourRole == 'B') {
      if (mazeMap.value.Player_B_Coord.row == 17 &&
          mazeMap.value.Player_B_Coord.col == 10) {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(gameId.value)
            .update({
          'scrollOwner': 'B',
        });
        await FlameAudio.play('sfx_scroll.mp3');
        setUpMessage(4, textOfMazeScroll);
      }
    }
  }

  void changeState(
      Coordinates Player_L_Coord, GameInfo gameInfo, String role) async {
    if (role == 'A') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_A': gameInfo.GameInfoToCloud(yourRole).toJson(),
        'Player_A_Coord': Player_L_Coord.toJson(),
      });
    } else if (role == 'B') {
      await firebaseFirestore
          .collection('gameBattle')
          .doc(gameId.value)
          .update({
        'GameInfo_B': gameInfo.GameInfoToCloud(yourRole).toJson(),
        'Player_B_Coord': Player_L_Coord.toJson(),
      });
    }
  }

  void updateCoordinates(String gameInfoS, String playerCoord,
      String scrollOwner, String currentPlayerRole) {
    var gameI = GameInfoCloud.fromJson(gameInfoS);
    var gameData =
        gameI.CloudToGameInfo(currentPlayerRole, gameInfo.value, scrollOwner);

    var playerCoordValue = Coordinates.fromJson(playerCoord);
    if (currentPlayerRole == "A") {
      gameInfo.value = gameData;
      mazeMap.value.Player_B_Coord = playerCoordValue;
    } else if (currentPlayerRole == "B") {
      gameInfo.value = GameInfo.reverseGameInfo(gameData, mazeMap.value);
      mazeMap.value.Player_A_Coord = playerCoordValue;
    }
  }

  void finish_game(String player) async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .update({'Player_${player}_ready': false});
    Get.offNamed(Routes.END_GAME_SCREEN);
  }

  void allDirFalse() {
    right.value = false;
    left.value = false;
    up.value = false;
    down.value = false;
    update();
  }

  Coordinates swapCoordinates(Coordinates Player_Coord, int width, int hight) {
    var Player_L_Coord = Coordinates(
        isInit: Player_Coord.isInit,
        row: (hight - 1) - Player_Coord.row,
        col: (width - 1) - Player_Coord.col);
    return Player_L_Coord;
  }

  void MovePlayer(Direction direction) {
    Coordinates player;
    if (yourRole == 'A') {
      player = mazeMap.value.Player_A_Coord;
    } else if (yourRole == 'B') {
      player = mazeMap.value.Player_B_Coord;
    } else {
      return;
    }
    if (_trapsController.frozenDeactivation()) {
      return;
    }
    switch (direction) {
      case Direction.up:
        if (player.row != 0) {
          if (!mazeMap.value.mazeMap[player.row - 1][player.col].wall ||
              _trapsController.playerGhost > 0) {
            player.row -= 1;
            _trapsController.playStep();
          }
        }
        break;
      case Direction.down:
        if (player.row != mazeMap.value.mazeMap.length - 1) {
          if (!mazeMap.value.mazeMap[player.row + 1][player.col].wall ||
              _trapsController.playerGhost > 0) {
            player.row += 1;
            _trapsController.playStep();
          }
        }
        break;
      case Direction.left:
        if (player.col != 0) {
          if (!mazeMap.value.mazeMap[player.row][player.col - 1].wall ||
              _trapsController.playerGhost > 0) {
            player.col -= 1;
            _trapsController.playStep();
          }
        }
        break;
      case Direction.right:
        if (player.col != mazeMap.value.mazeMap[0].length - 1) {
          if (!mazeMap.value.mazeMap[player.row][player.col + 1].wall ||
              _trapsController.playerGhost > 0) {
            player.col += 1;
            _trapsController.playStep();
          }
        }
        break;
      default:
    }
    if (_trapsController.playerGhost > 0) {
      _trapsController.playerGhost--;
    }
    if (yourRole == 'A') {
      mazeMap.value.Player_A_Coord = player;
    } else if (yourRole == 'B') {
      mazeMap.value.Player_B_Coord = player;
    }
  }

  String setUpMessageAfterTrap(int trapId) {
    double distance =
        double.parse(mazeMap.value.calculateDistance().toStringAsFixed(2));
    messageCounter = 4;
    if (trapId == 12) {
      return 'You are invisible for the enemy next 20 sec';
    }
    return 'The enemy fell into your trap. Distance between you: $distance';
  }

  void changeInit(int id, String role) {
    if (role == 'A') {
      switch (id) {
        case 1:
          gameInfo.value.Frozen_trap_A.isInit = false;
          break;
        case 2:
          gameInfo.value.Teleport_A.isInit = false;
          break;
        case 3:
          gameInfo.value.Bomb_A.isInit = false;
          break;
        case 4:
          gameInfo.value.Knifes_A.isInit = false;
          break;
        case 5:
          gameInfo.value.Speed_increase_1_5_A.isInit = false;
          break;
        case 6:
          gameInfo.value.Speed_increase_2_A.isInit = false;
          break;
        case 7:
          gameInfo.value.Go_through_the_wall_A.isInit = false;
          break;
        case 8:
          gameInfo.value.Blindness_A.isInit = false;
          break;
        case 9:
          gameInfo.value.Poison_A.isInit = false;
          break;
        case 10:
          gameInfo.value.Healing_A.isInit = false;
          break;
        case 11:
          gameInfo.value.Meteor_A.isInit = false;
          break;
        case 12:
          gameInfo.value.Invisibility_A.isInit = false;
          break;
        case 13:
          gameInfo.value.Builder_A.isInit = false;
          break;
        default:
      }
    } else {
      switch (id) {
        case 1:
          gameInfo.value.Frozen_trap_B.isInit = false;
          break;
        case 2:
          gameInfo.value.Teleport_B.isInit = false;
          break;
        case 3:
          gameInfo.value.Bomb_B.isInit = false;
          break;
        case 4:
          gameInfo.value.Knifes_B.isInit = false;
          break;
        case 5:
          gameInfo.value.Speed_increase_1_5_B.isInit = false;
          break;
        case 6:
          gameInfo.value.Speed_increase_2_B.isInit = false;
          break;
        case 7:
          gameInfo.value.Go_through_the_wall_B.isInit = false;
          break;
        case 8:
          gameInfo.value.Blindness_B.isInit = false;
          break;
        case 9:
          gameInfo.value.Poison_B.isInit = false;
          break;
        case 10:
          gameInfo.value.Healing_B.isInit = false;
          break;
        case 11:
          gameInfo.value.Meteor_B.isInit = false;
          break;
        case 12:
          gameInfo.value.Invisibility_B.isInit = false;
          break;
        case 13:
          gameInfo.value.Builder_B.isInit = false;
          break;
        default:
      }
    }
  }
}
