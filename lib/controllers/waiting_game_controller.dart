import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/models/gameInfoCloud.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import '../services/generate_maze.dart';
import '../services/map_operation.dart';
import 'main_game_controller.dart';

class WaitingGameController extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxString gameStatus = 'searching...'.obs;
  RxString nameOfMap = 'searching...'.obs;
  Rx<bool> startButtonShow = false.obs;
  String playerWhoIInvite_ID = '';
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;

  @override
  void onInit() async {
    if (!mainCtrl.randomRival) {
      if (mainCtrl.YourCurrentRole == 'A') {
        await _addPlayerToList(mainCtrl.randomRival);

        await firebaseFirestore
            .collection('users')
            .doc(mainCtrl.playerWhoIInvite_ID)
            .update({
          'isAnybodyAscMe': true,
          'whoInviteMeToPlay': mainCtrl.userName.value,
          'theGameIdInviteMe': mainCtrl.currentmultiplayerGameId
        });
      } else if (mainCtrl.YourCurrentRole == 'B') {
        startGameStream(mainCtrl.currentmultiplayerGameId);
      }
    } else {
      _adPlayerToQueueOrFindRival();
    }
    super.onInit();
  }

  @override
  void onClose() {
    listner.cancel();
    mainCtrl.deleteGameInstant();
    super.onClose();
  }

  void _adPlayerToQueueOrFindRival() async {
    var playerList = await FirebaseFirestore.instance
        .collection('gameBattle')
        .where('gameStatus', isEqualTo: 'searching')
        .get();

    if (playerList.docs.length < 1) {
      _addPlayerToList(mainCtrl.randomRival);
    } else {
      await FirebaseFirestore.instance
          .collection('gameBattle')
          .doc(playerList.docs[0].id)
          .update({
        'Player_B_uid': mainCtrl.userUid,
        'Player_B_Name': mainCtrl.userName.value,
        'gameStatus': 'waiting'
      });
      var data = playerList.docs[0].data();

      String map = data['Map'];
      mainCtrl.currentGameMap = MazeMap.fromJson(map);
      mainCtrl.currentmultiplayerGameId = playerList.docs[0].id;
      mainCtrl.YourCurrentRole = 'B'.obs;
      startGameStream(playerList.docs[0].id);
    }
  }

  Future<void> _addPlayerToList(bool randomRival) async {
    if (randomRival) {
      mainCtrl.currentGameMap = await mainCtrl.generateNewRandomMap();
    }
    try {
      var doc = await firebaseFirestore.collection('gameBattle').add({
        'randomRival': randomRival,
        'scrollOwner': 'none',
        'IcantPlay': false,
        'Map': mainCtrl.currentGameMap!.toJson(),
        'Player_A_uid': mainCtrl.userUid,
        'Player_A_Name': mainCtrl.userName.value,
        'Player_A_ready': false,
        'Player_B_uid': '',
        'Player_B_Name': '',
        'Player_B_ready': false,
        'B_used_trap': false,
        'A_used_trap': false,
        'Player_A_Life': mainCtrl.globalSettings.default_health,
        'Player_B_Life': mainCtrl.globalSettings.default_health,
        'Player_A_Coord': Coordinates(isInit: false, row: 0, col: 0).toJson(),
        'Player_B_Coord': Coordinates(isInit: false, row: 0, col: 0).toJson(),
        'Player_A_caught': 0,
        'Player_B_caught': 0,
        'GameInfo_A': GameInfoCloud.createEmptyForServer().toJson(),
        'GameInfo_B': GameInfoCloud.createEmptyForServer().toJson(),
        'vinner': '',
        'gameStatus': 'searching',
        'date': DateTime.now(),
      });
      mainCtrl.YourCurrentRole = 'A'.obs;
      mainCtrl.currentmultiplayerGameId = doc.id;
      startGameStream(doc.id);
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('1${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void startGameStream(String id) async {
    print(mainCtrl.YourCurrentRole);
    snapshots =
        FirebaseFirestore.instance.collection('gameBattle').doc(id).snapshots();
    listner = snapshots.listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        gameStatus.value = data!['gameStatus'];
        bool IcantPlay = data['IcantPlay'];
        if (IcantPlay) {
          listner.cancel();
          mainCtrl.changeStatusInGame(false);
          firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .delete();
          Get.offNamed(Routes.GENERAL_MENU);
          Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Player refuses to play'),
            backgroundColor: Colors.red,
          ));
        }
        if (gameStatus.value == 'waiting') {
          startButtonShow.value = true;
          update();
        }
        if (gameStatus.value == 'playing') {
          gameStatus.value = 'game';
          Get.offNamed(Routes.BATTLE_ACT);
          firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'game',
          });
        }
      } else {
        print('Document does not exist');
      }
    });
    update();
  }

  Future<bool> chooseRandomMap() async {
    try {
      var maps = await FirebaseFirestore.instance
          .collection('maps')
          .orderBy('rating', descending: false)
          .limit(10)
          .get();
      int randomInt = Random().nextInt(maps.docs.length);

      if (maps.docs[randomInt].exists) {
        mainCtrl.currentMapId = maps.docs[randomInt]['id'];

        mainCtrl.currentGameMap = MazeMap.fromJson(maps.docs[randomInt]['map']);
        mainCtrl.currentMapName = maps.docs[randomInt]['name'];

        // prepareMapToGame();
        return true;
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ));
      }
    } on FirebaseException catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
    return false;
  }

  void toPlay() async {
    try {
      var doc = await firebaseFirestore
          .collection('gameBattle')
          .doc(mainCtrl.currentmultiplayerGameId)
          .get();
      if (mainCtrl.YourCurrentRole == 'A') {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_A_ready': true,
        });
        if (doc.data()!['Player_B_ready'] == true) {
          await firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
          });
        }
      } else if (mainCtrl.YourCurrentRole == 'B') {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(mainCtrl.currentmultiplayerGameId)
            .update({
          'Player_B_ready': true,
        });
        if (doc.data()!['Player_A_ready'] == true) {
          await firebaseFirestore
              .collection('gameBattle')
              .doc(mainCtrl.currentmultiplayerGameId)
              .update({
            'gameStatus': 'playing',
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
        content: Text('${error.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
