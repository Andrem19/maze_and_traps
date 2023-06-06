import 'dart:async';

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
  Rx<String> timerText = ''.obs;

  String gameStatus = '';
  String yourRole = 'A';
  Rx<String> textMessage = ''.obs;
  Rx<Direction> moveDirection = Direction.up.obs;
  int shaddowRadius = 3;
  int timerDuration = 1200;
  var _stream;
  var oldSubscription;

  RxBool up = false.obs;
  RxBool down = false.obs;
  RxBool left = false.obs;
  RxBool right = false.obs;

  @override
  void onInit() {
    mainCtrl.changeStatusInGame(true);
    gameEngine();
    super.onInit();
  }

  @override
  void onClose() async {
    await playerNotReady();
    mainCtrl.deleteGameInstant();
    mainCtrl.changeStatusInGame(false);
    oldSubscription?.cancel();
    _stream?.cancel();
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
      listner.cancel();
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
    await firebaseFirestore.collection('gameBattle').doc(gameId.value).update({
      'gameStatus': 'finish',
      'Player_${yourRole}_ready': false,
    });
    mainCtrl.vinner = vinner;
  }

  Future<void> setUpVars() async {
    late TrapsController trapsController;
    mazeMap = mainCtrl.YourCurrentRole == 'B'
        ? mainCtrl.currentGameMap!.reversePlus().obs
        : mainCtrl.currentGameMap!.obs;
    gameId.value = mainCtrl.currentmultiplayerGameId;
    yourRole = mainCtrl.YourCurrentRole;
    mazeWidth = mazeMap.value.mazeMap.length;
    mazeHight = mazeMap.value.mazeMap[0].length;
    shaddowRadius = mainCtrl.globalSettings.default_shaddow_radius;
    timerDuration = mainCtrl.globalSettings.speed_1;
    // movePlayerA = mazeMap.value.MovePlayer_A;
    countRadiusAroundPlayerA = mazeMap.value.countRadiusAroundPlayer_A;
    // movePlayerB = mazeMap.value.MovePlayer_B;
    countRadiusAroundPlayerB = mazeMap.value.countRadiusAroundPlayer_B;
    checkTheFinishA = mazeMap.value.checkTheFinish_A;
    checkTheFinishB = mazeMap.value.checkTheFinish_B;
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
          coordinatesOfEnemy_for_A(gameInfoB, playerBCoord);
          final gameStatus = data['gameStatus'];
          if (gameStatus == 'finish') {
            A_finish_game();
          }
        } else if (yourRole == 'B') {
          final gameInfoA = data['GameInfo_A'];
          final playerACoord = data['Player_A_Coord'];
          coordinatesOfEnemy_for_B(gameInfoA, playerACoord);
          gameStatus = data['gameStatus'];
          if (gameStatus == 'finish') {
            B_finish_game();
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
    _stream = Stream.periodic(Duration(milliseconds: 1000), (_) => updateUI())
        .listen((event) {
      update();
    });
  }

  updateUI() {
    moveDirection.value = mainCtrl.moveDir;
    _trapsController.checkAllTraps();
    if (yourRole == 'A') {
      MovePlayer(moveDirection.value);
      countRadiusAroundPlayerA(shaddowRadius, true);
      // textMessage.value = mazeMap.value.message_A;

      final res = checkTheFinishA();
      if (res) {
        countFinal('A');
        mainCtrl.vinner = 'A';
      }
    } else if (yourRole == 'B') {
      MovePlayer(moveDirection.value);
      countRadiusAroundPlayerB(shaddowRadius, true);
      // textMessage.value = mazeMap.value.message_B;

      final res = checkTheFinishB();
      if (res) {
        countFinal('B');
        mainCtrl.vinner = 'B';
      }
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

  void changeState(
      Coordinates Player_L_Coord, GameInfo gameInfo, String role) async {
    print(role);
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

  void coordinatesOfEnemy_for_A(String gameInfo_B, String Player_B_Coord) {
    var gameI = GameInfoCloud.fromJson(gameInfo_B);
    gameInfo.value = gameI.CloudToGameInfo(yourRole, gameInfo.value);

    mazeMap.value.Player_B_Coord = Coordinates.fromJson(Player_B_Coord);
  }

  void coordinatesOfEnemy_for_B(String gameInfo_A, String Player_A_Coord) {
    var gameI = GameInfoCloud.fromJson(gameInfo_A);
    gameInfo.value = GameInfo.reverseGameInfo(gameI.CloudToGameInfo(yourRole, gameInfo.value), mazeMap.value);
    
    mazeMap.value.Player_A_Coord = Coordinates.fromJson(Player_A_Coord);
  }

  void B_finish_game() async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .update({'Player_B_ready': false});
    Get.offNamed(Routes.END_GAME_SCREEN);
  }

  void A_finish_game() async {
    await firebaseFirestore
        .collection('gameBattle')
        .doc(gameId.value)
        .update({'Player_A_ready': false});
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
        row: (width - 1) - Player_Coord.row,
        col: (hight - 1) - Player_Coord.col);
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
          if (!mazeMap.value.mazeMap[player.row - 1][player.col].wall) {
            player.row -= 1;
          }
        }
        break;
      case Direction.down:
        if (player.row != mazeMap.value.mazeMap.length - 1) {
          if (!mazeMap.value.mazeMap[player.row + 1][player.col].wall) {
            player.row += 1;
          }
        }
        break;
      case Direction.left:
        if (player.col != 0) {
          if (!mazeMap.value.mazeMap[player.row][player.col - 1].wall) {
            player.col -= 1;
          }
        }
        break;
      case Direction.right:
        if (player.col != mazeMap.value.mazeMap[0].length - 1) {
          if (!mazeMap.value.mazeMap[player.row][player.col + 1].wall) {
            player.col += 1;
          }
        }
        break;
      default:
    }
    if (yourRole == 'A') {
      mazeMap.value.Player_A_Coord = player;
    } else if (yourRole == 'B') {
      mazeMap.value.Player_B_Coord = player;
    }
  }

  // void MovePlayer_A(Direction direction) {
  //   if (_trapsController.frozenDeactivation()) {
  //     return;
  //   }
  //   switch (direction) {
  //     case Direction.up:
  //       if (mazeMap.value.Player_A_Coord.row != 0) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_A_Coord.row - 1]
  //                 [mazeMap.value.Player_A_Coord.col]
  //             .wall) {
  //           mazeMap.value.Player_A_Coord.row -= 1;
  //         }
  //       }
  //       break;
  //     case Direction.down:
  //       if (mazeMap.value.Player_A_Coord.row !=
  //           mazeMap.value.mazeMap.length - 1) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_A_Coord.row + 1]
  //                 [mazeMap.value.Player_A_Coord.col]
  //             .wall) {
  //           mazeMap.value.Player_A_Coord.row += 1;
  //         }
  //       }
  //       break;
  //     case Direction.left:
  //       if (mazeMap.value.Player_A_Coord.col != 0) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_A_Coord.row]
  //                 [mazeMap.value.Player_A_Coord.col - 1]
  //             .wall) {
  //           mazeMap.value.Player_A_Coord.col -= 1;
  //         }
  //       }
  //       break;
  //     case Direction.right:
  //       if (mazeMap.value.Player_A_Coord.col !=
  //           mazeMap.value.mazeMap[0].length - 1) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_A_Coord.row]
  //                 [mazeMap.value.Player_A_Coord.col + 1]
  //             .wall) {
  //           mazeMap.value.Player_A_Coord.col += 1;
  //         }
  //       }
  //       break;
  //     default:
  //   }
  // }

  // void MovePlayer_B(Direction direction) {
  //   if (_trapsController.frozenDeactivation()) {
  //     return;
  //   }
  //   switch (direction) {
  //     case Direction.up:
  //       if (mazeMap.value.Player_B_Coord.row != 0) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_B_Coord.row - 1]
  //                 [mazeMap.value.Player_B_Coord.col]
  //             .wall) {
  //           mazeMap.value.Player_B_Coord.row -= 1;
  //         }
  //       }
  //       break;
  //     case Direction.down:
  //       if (mazeMap.value.Player_B_Coord.row !=
  //           mazeMap.value.mazeMap.length - 1) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_B_Coord.row + 1]
  //                 [mazeMap.value.Player_B_Coord.col]
  //             .wall) {
  //           mazeMap.value.Player_B_Coord.row += 1;
  //         }
  //       }
  //       break;
  //     case Direction.left:
  //       if (mazeMap.value.Player_B_Coord.col != 0) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_B_Coord.row]
  //                 [mazeMap.value.Player_B_Coord.col - 1]
  //             .wall) {
  //           mazeMap.value.Player_B_Coord.col -= 1;
  //         }
  //       }
  //       break;
  //     case Direction.right:
  //       if (mazeMap.value.Player_B_Coord.col !=
  //           mazeMap.value.mazeMap[0].length - 1) {
  //         if (!mazeMap
  //             .value
  //             .mazeMap[mazeMap.value.Player_B_Coord.row]
  //                 [mazeMap.value.Player_B_Coord.col + 1]
  //             .wall) {
  //           mazeMap.value.Player_B_Coord.col += 1;
  //         }
  //       }
  //       break;
  //     default:
  //   }
  // }
}
