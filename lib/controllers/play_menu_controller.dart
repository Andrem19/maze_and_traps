import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/waiting_game_controller.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';

class PlayMenuController extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void invitePlayerForBattle() async {
    await mainCtrl.deleteAllMyGamesIfExist();
    if (mainCtrl.mapSearch.text.length > 0) {
      var map = await firebaseFirestore
          .collection('maps')
          .where('name', isEqualTo: mainCtrl.mapSearch.text)
          .get();
      if (map.docs.length > 0) {
        var data = map.docs[0].data();
        mainCtrl.currentGameMap = MazeMap.fromJson(data['map']);
      } else {
        mainCtrl.currentGameMap = await mainCtrl.generateNewRandomMap();
      }
    } else {
      mainCtrl.currentGameMap = await mainCtrl.generateNewRandomMap();
    }
    var doc = await firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: mainCtrl.playerSearch.text)
        .get();
    if (doc.docs.length > 0) {
      var data = doc.docs[0].data();
      bool status = data['isUserInGame'] as bool;
      bool alowed = data['wantToPlay'] as bool;
      if (alowed) {
        if (status) {
          Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('This user currently playing another game'),
            backgroundColor: Colors.red,
          ));
          return;
        }
        mainCtrl.changeStatusInGame(true);
        mainCtrl.YourCurrentRole = 'A'.obs;
        mainCtrl.playerWhoIInvite_ID = doc.docs[0].id;//????
        mainCtrl.randomRival = false;

        Get.toNamed(Routes.WAITING_PAGE);
        mainCtrl.playerSearch.clear();
      } else if (!alowed) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Player has disabled game invites'),
          backgroundColor: Colors.red,
        ));
        return;
      }
    }
  }

  void setUpRandomRival(bool randomRival) async {
    mainCtrl.randomRival = randomRival;
  }
}
