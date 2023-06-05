import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../keys.dart';
import '../models/maze_map.dart';
import '../models/settings.dart';
import '../models/trap.dart';
import '../services/generate_traps.dart';

class MainGameController extends GetxController {
  GlobalSettings globalSettings = GlobalSettings(
      default_health: 55,
      default_shaddow_radius: 3,
      shaddow_radius_with_buf: 5,
      speed_1: 1200,
      speed_2: 800,
      speed_3: 600,
      timer_back_for_battle: 240,
      timer_back_for_training: 600);
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
  bool randomRival = false;
  String YourCurrentRole = 'A';
  String currentMapName = '';
  String currentmultiplayerGameId = '';
  String currentMapId = '';
  String playerWhoIInvite_ID = '';
  Direction moveDir = Direction.up;
  RxBool wantToPlay = false.obs;
  RxDouble player_A_Life = 55.0.obs;
  RxDouble player_B_Life = 55.0.obs;
  String vinner = '';

  @override
  void onInit() async {
    globalSettings = await loadSettings();
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
        'wantToPlay': true,
        'lastActive': FieldValue.serverTimestamp(),
        'points': 0,
      });
      pref.setString('secretToken', secrTok);
      pref.setString('uid', uid);
      userName.value = 'Pl-$part';
      wantToPlay.value = true;
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

  void changeInGameLastTime() async {
    await firebaseFirestore.collection('users').doc(userUid).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> checkUserLastTimeOnline(int MAX_OFFLINE_TIME) async {
    try {
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection('users').doc(userUid).get();
      Timestamp lastInGame = snapshot['lastActive'];
      var currentTime = Timestamp.now();
      if (lastInGame != null) {
        var difference = currentTime.seconds - lastInGame.seconds;
        if (difference > MAX_OFFLINE_TIME) {
          false;
        } else
          return true;
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

  void changeWantToPlay() async {
    await firebaseFirestore.collection('users').doc(userUid).update({
      'wantToPlay': wantToPlay.value,
    });
    if (wantToPlay.value) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content:
            Text('You have allowed other players to invite you to the game.'),
        backgroundColor: Colors.green,
      ));
    } else {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(
            'You have blocked other players from inviting you to the game.'),
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
        wantToPlay.value = data['wantToPlay'];
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
  ///
  void deleteGameInstant() async {
    var doc = await firebaseFirestore
        .collection('gameBattle')
        .doc(currentmultiplayerGameId)
        .get();
    if (doc.exists) {
      var data = doc.data();
      bool Player_A = data!['Player_A_ready'];
      bool Player_B = data['Player_B_ready'];
      if (!Player_A && !Player_B) {
        await firebaseFirestore
            .collection('gameBattle')
            .doc(currentmultiplayerGameId)
            .delete();
      }
    }
  }

  Future<void> agreeToPlayPreparing(String theGameIdInviteMe) async {
    try {
      firebaseFirestore.collection('gameBattle').doc(theGameIdInviteMe).update({
        'Player_B_uid': userUid,
        'Player_B_Name': userName.value,
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
          currentGameMap = MazeMap.fromJson(data['map']);
          // prepareMapToGame();
        }
        currentmultiplayerGameId = theGameIdInviteMe;
        currentMapName = data['MapName'];
        YourCurrentRole = 'B';
      }
      Get.toNamed(Routes.WAITING_PAGE);
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

  void changeStatusInGame(bool status) async {
    await firebaseFirestore.collection('users').doc(userUid).update({
      'isUserInGame': status,
    });
    IsUserInGame = status;
  }

  GlobalSettings fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final Map<String, dynamic> data = snapshot.data() ?? {};
    // Parse the data and return a new Settings object
    return GlobalSettings(
      default_health: data['default_health'] as int? ?? 0,
      default_shaddow_radius: data['default_shaddow_radius'] as int? ?? 0,
      shaddow_radius_with_buf: data['shaddow_radius_with_buf'] as int? ?? 0,
      speed_1: data['speed_1'] as int? ?? 0,
      speed_2: data['speed_2'] as int? ?? 0,
      speed_3: data['speed_3'] as int? ?? 0,
      timer_back_for_battle: data['timer_back_for_battle'] as int? ?? 0,
      timer_back_for_training: data['timer_back_for_training'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore(
      GlobalSettings settings, SetOptions? options) {
    // Convert the Settings object back into a map
    return {
      'default_health': settings.default_health,
      'default_shaddow_radius': settings.default_shaddow_radius,
      'shaddow_radius_with_buf': settings.shaddow_radius_with_buf,
      'speed_1': settings.speed_1,
      'speed_2': settings.speed_2,
      'speed_3': settings.speed_3,
      'timer_back_for_battle': settings.timer_back_for_battle,
      'timer_back_for_training': settings.timer_back_for_training,
    };
  }

  Future<GlobalSettings> loadSettings() async {
    var doc = await firebaseFirestore
        .collection('globalSettings')
        .doc('settings_1')
        .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore)
        .get();
    var data = doc.data();
    player_A_Life.value = data!.default_health.toDouble();
    player_B_Life.value = data!.default_health.toDouble();
    if (data != null) {
      return data;
    }
    return GlobalSettings(
        default_health: 55,
        default_shaddow_radius: 3,
        shaddow_radius_with_buf: 5,
        speed_1: 1200,
        speed_2: 800,
        speed_3: 600,
        timer_back_for_battle: 240,
        timer_back_for_training: 600);
  }

  void playSwipe(int num) async {
    num % 2 == 0
        ? await FlameAudio.play('sfx_Swipe.mp3')
        : await FlameAudio.play('sfx_Swipe1.mp3');
  }
}
