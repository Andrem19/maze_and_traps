import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/services/map_operation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../keys.dart';
import '../models/maze_map.dart';
import '../models/trap.dart';
import '../services/generate_traps.dart';

class MainGameController extends GetxController {

  MazeMap? currentGameMap;
  List<Trap> allTrapsInTheGame = TrapsGenerator.getTraps();
  RxList<Trap> allMyTraps = <Trap>[].obs;
  RxList<Trap> backpackSet = <Trap>[].obs;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listner;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late SharedPreferences pref;
  RxString userName = ''.obs;
  String userUid = '';
  RxInt points = 0.obs;
  RxInt scrolls = 0.obs;
  RxList<dynamic> scrollsList = <dynamic>[].obs;

  TextEditingController playerSearch = TextEditingController(text: '');
  TextEditingController targetQrCode = TextEditingController();

  bool IsUserInGame = false;
  String YourCurrentRole = 'A';
  String currentMapName = '';
  String currentmultiplayerGameId = '';
  String currentMapId = '';
  Direction moveDir = Direction.up;

  @override
  void onInit() async {
    pref = await SharedPreferences.getInstance();
    authenticate();
    super.onInit();
  }

  @override
  void onClose() {
    destroyListner();
    super.onClose();
  }

  void playButton() {
    // FlameAudio.play('button_change_direction.ogg');
  }

  ////   AUTHORIZATION ////
  Future<void> authenticate() async {
    String secretToken = pref.getString('secretToken') ?? 'none';
    if (secretToken == 'none') {
      await registerNewUser();
    } else if (secretToken != 'none') {
      await checkUserAuth();
    }
    await firebaseFirestore.collection('users').doc(userUid).update({
      'isUserInGame': false,
      'isAnybodyAscMe': false,
    });
    await setUpListner(userUid);
  }

  Future<bool> chekNameExist(String name) async {
    try {
      var doc = await firebaseFirestore
          .collection('users')
          .where('name', isEqualTo: name)
          .get();
      if (doc.docs.length > 0) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('This name exist. Create another name'),
          backgroundColor: Colors.red,
        ));
        return true;
      } else {
        return false;
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
    return false;
  }

  Future<void> registerNewUser() async {
    String uid = uuid.v4();
    String part = uid.substring(30);
    String secrTok = uuid.v4();
    for (var i = 0; i < 200; i++) {
      scrollsList.add('scroll');
    }

    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': 'Pl-$part',
        'secretToken': secrTok,
        'migrationToken': '',
        'isUserInGame': false,
        'isAnybodyAscMe': false,
        'whoInviteMeToPlay': '',
        'theGameIdInviteMe': '',
        'scrolls': scrollsList,
        'allTraps': [],
        'mySetOfTraps': ['Blindness'],
        'weight': 3,
        'weightPrice': 2,
        'points': 0,
      });
      pref.setString('secretToken', secrTok);
      pref.setString('uid', uid);
      userName.value = 'Pl-$part';
      points.value = 0;
      userUid = uid;
      allMyTraps.value = TrapsGenerator.toListTraps([], allTrapsInTheGame);
      backpackSet.value =
          TrapsGenerator.toListTraps(['Blindness'], allTrapsInTheGame);
      scrolls.value = scrollsList.length;
      update();
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

  Future<void> checkUserAuth() async {
    String uid = pref.getString('uid') ?? 'none';
    String secretT = pref.getString('secretToken') ?? 'none';
    if (uid == 'none') {
      registerNewUser();
    }
    try {
      var document = await firebaseFirestore.collection('users').doc(uid).get();
      if (document.exists) {
        var data = document.data();
        String token = data!['secretToken'];
        if (secretT != token) {
          registerNewUser();
        }
        points.value = data['points'];
        userName.value = data['name'];
        userUid = data['uid'];
        scrollsList.value = data['scrolls'];
        allMyTraps.value =
            TrapsGenerator.toListTraps(data['allTraps'], allTrapsInTheGame);
        backpackSet.value =
            TrapsGenerator.toListTraps(data['mySetOfTraps'], allTrapsInTheGame);
        scrolls.value = scrollsList.length;
      } else {
        registerNewUser();
      }
      update();
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

  //// Listner and game logic ////

  Future<void> agreeToPlayPreparing(String theGameIdInviteMe) async {
    try {
      firebaseFirestore.collection('gameBattle').doc(theGameIdInviteMe).update({
        'Player_B_uid': userUid,
        'Player_B_Name': userName,
        'gameStatus': 'waiting'
      });
      var doc = await firebaseFirestore
          .collection('gameBattle')
          .doc(theGameIdInviteMe)
          .get();

      if (doc.exists) {
        var data = doc.data();

        currentMapId = data!['Map_Id'];
        var maps = await FirebaseFirestore.instance
            .collection('maps')
            .where('id', isEqualTo: currentMapId)
            .get();
        if (maps.docs.length > 0) {
          var data = maps.docs[0].data();
          // currentGameMap = MazeMap.fromJson(data['map']);
          // prepareMapToGame();
        }
        currentmultiplayerGameId = theGameIdInviteMe;
        currentMapName = data['MapName'];
        YourCurrentRole = 'B';
      }
      // Get.toNamed(Routes.INVITE_BATTLE); !!!!!!!
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

  void destroyListner() {
    listner.cancel();
    changeStatusInGame(false);
  }

  Future<void> setUpListner(String userId) async {
    snapshots =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    listner = snapshots.listen((data) {
      bool isAnybodyAscMe = data['isAnybodyAscMe'];
      String whoAskMe = data['whoInviteMeToPlay'];
      String theGameIdInviteMe = data['theGameIdInviteMe'];
      print('game_id: $theGameIdInviteMe');
      if (isAnybodyAscMe) {
        firebaseFirestore.collection('users').doc(userUid).update({
          'isAnybodyAscMe': false,
        });
        changeStatusInGame(true);
        Get.dialog(AlertDialog(
            title: Text('$whoAskMe invite your to the game'),
            content: const Text('Do you want to play?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  changeStatusInGame(false);
                  firebaseFirestore
                      .collection('gameBattle')
                      .doc(theGameIdInviteMe)
                      .update({
                    'IcantPlay': true,
                  });
                  Get.back();
                },
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  agreeToPlayPreparing(theGameIdInviteMe);
                },
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ]));
      }
    });
  }

  void changeStatusInGame(bool status) {
    firebaseFirestore.collection('users').doc(userUid).update({
      'isUserInGame': status,
    });
    IsUserInGame = status;
  }


}
