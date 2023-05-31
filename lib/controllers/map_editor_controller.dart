import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/models/game_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../keys.dart';
import '../models/maze_map.dart';
import '../services/check_maze_valid.dart';
import '../services/editor_page.dart';
import '../services/map_operation.dart';
import 'main_game_controller.dart';

class MapEditorController extends GetxController {
  int priceToSaveMap = 2;
  Rx<bool> isLoading = false.obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late GameInfo dumbGameInfo = GameInfo.createEmptyGameInfo(mazeMap);
  late MainGameController mainCtrlr;
  late Stream<QuerySnapshot> maps;
  late SharedPreferences pref;
  var uuid = Uuid();
  TextEditingController mapNameController = TextEditingController();

  late Rx<MazeMap> _mazeMap =
      EditorPageMap.createStruct(TestData.createTestMap()).obs;

  MazeMap get mazeMap => _mazeMap.value;

  @override
  void onInit() async {
    mainCtrlr = Get.find<MainGameController>();
    maps = FirebaseFirestore.instance
        .collection('maps')
        .where('author', isEqualTo: mainCtrlr.userUid)
        .snapshots();
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  void changeWall(int row, int col) {
    if (_mazeMap.value.mazeMap[row][col].editAlowd) {
      _mazeMap.value.mazeMap[row][col].wall =
          !_mazeMap.value.mazeMap[row][col].wall;

      int mirrorRow = _mazeMap.value.mazeMap.length - row - 1;
      int mirrorCol = _mazeMap.value.mazeMap[0].length - col - 1;
      _mazeMap.value.mazeMap[mirrorRow][mirrorCol].wall =
          _mazeMap.value.mazeMap[row][col].wall;
    }
    update();
  }

  Future<bool> checkMazeValid() async {
    bool isValid = await CheckMazeValid.findPath(mazeMap.mazeMap,
        mazeMap.mazeMap.length - 1, 0, 0, mazeMap.mazeMap[0].length - 1);
    if (!isValid) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content:
            Text('Maze is not valid. Sould be the path from Start to Finish'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return true;
  }

  void saveMap() async {
    bool res = await checkAndChargeScrolls();
    if (!res) {
      return;
    }
    String id = uuid.v4();
    try {
      if (mapNameController.text != '') {
        String normalizedName = mapNameController.text.toLowerCase();
        var isNameExist = await FirebaseFirestore.instance
            .collection('maps')
            .where('name', isEqualTo: normalizedName)
            .get();
        if (isNameExist.size == 0) {
          await firebaseFirestore.collection('maps').add({
            'name': normalizedName,
            'id': id,
            'author': mainCtrlr.userUid,
            'authorName': mainCtrlr.userName.value,
            'map': mazeMap.toJson(),
            'champions': new Map(),
            'rating': 0
          });
          Get.back();
          Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Map saved'),
            backgroundColor: Color.fromARGB(255, 54, 244, 67),
          ));
        } else {
          Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Name exist'),
            backgroundColor: Colors.red,
          ));
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

  void loadMap(String name) async {
    isLoading.value = true;
    try {
      var map = await firebaseFirestore
          .collection('maps')
          .where('name', isEqualTo: name)
          .get();
      if (map.docs.isEmpty) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Can\'t load the map'),
          backgroundColor: Colors.red,
        ));
      }
      if (!map.docs[0].exists) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Cant\' load the map'),
          backgroundColor: Colors.red,
        ));
      }
      var mapJson = map.docs[0]['map'];
      var maze = MazeMap.fromJson(mapJson);
      _mazeMap.value = maze;
      Get.toNamed(Routes.MAP_EDITOR);
      isLoading.value = false;
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
      print(error.toString());
    }
  }

  Future<bool> checkAndChargeScrolls() async {
    if (priceToSaveMap <= mainCtrlr.scrolls.value) {
      for (var i = 0; i < priceToSaveMap; i++) {
        mainCtrlr.scrollsList.removeLast();
      }
      try {
        await firebaseFirestore
            .collection('users')
            .doc(mainCtrlr.userUid)
            .update({'scrolls': mainCtrlr.scrollsList});
        mainCtrlr.authenticate();
        return true;
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
        print(error.toString());
      }
    } else {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('You need $priceToSaveMap scrolls to save map'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return false;
  }

  void createNewMap() {
    _mazeMap = EditorPageMap.createStruct(TestData.createTestMap()).obs;
    Get.toNamed(Routes.MAP_EDITOR);
  }
}
