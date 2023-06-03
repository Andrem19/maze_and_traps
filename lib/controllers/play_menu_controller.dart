import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';

class PlayMenuController extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void invitePlayerForBattle() async {
    print(1);
    var doc = await firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: mainCtrl.playerSearch.text)
        .get();
    if (doc.docs.length > 0) {
      print(mainCtrl.playerSearch.text);
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
        print(3);
        mainCtrl.changeStatusInGame(true);
        mainCtrl.YourCurrentRole = 'A';
        mainCtrl.playerWhoIInvite_ID = doc.docs[0].id;
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

  
}
