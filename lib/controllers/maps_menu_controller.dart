import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';

import '../keys.dart';
import '../models/champions copy.dart';
import '../models/maze_map.dart';
import 'main_game_controller.dart';

class MapsMenuController extends GetxController {
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxList<Champions> mapChampions =
      [Champions(name: 'nobody', seconds: 10000)].obs;
  TextEditingController queryKey = TextEditingController(text: '');

  late Stream<QuerySnapshot> maps;

  @override
  void onInit() {
    maps = FirebaseFirestore.instance
        .collection('maps')
        .orderBy('rating', descending: false)
        .limit(10)
        .snapshots();
    super.onInit();
  }

  void search(String query) async {
    String normalizedQuery = query.toLowerCase();
    try {
      if (normalizedQuery == '') {
        maps = FirebaseFirestore.instance
            .collection('maps')
            .orderBy('rating', descending: false)
            .limit(10)
            .snapshots();
      } else {
        maps = FirebaseFirestore.instance
            .collection('maps')
            .where('name', isGreaterThanOrEqualTo: normalizedQuery)
            .where('name', isLessThan: normalizedQuery + 'z')
            .snapshots();
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

  void prepareQuestGame(String mapId) async {
    try {
      var map = await firebaseFirestore
          .collection('maps')
          .where('id', isEqualTo: mapId)
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
      maze.shaddowRadius = 5;
      var ctrMain = Get.find<MainGameController>();
      ctrMain.currentGameMap = maze;
      ctrMain.currentMapId = map.docs[0].id;
      Get.toNamed(Routes.MAP_TRAINING_ACT);
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

  void loadMapChampions(String mapId) async {
    isLoading = true;
    try {
      var data = await firebaseFirestore
          .collection('maps')
          .where('id', isEqualTo: mapId)
          .get();
      Map<String, dynamic> champions =
          data.docs[0]['champions'] as Map<String, dynamic>;
      var keysList = champions.keys.toList();
      var valuesList = champions.values.toList();
      mapChampions.value.clear();
      for (var i = 0; i < keysList.length; i++) {
        mapChampions.value
            .add(Champions(name: keysList[i], seconds: valuesList[i] as int));
      }
      mapChampions.value.sort((a, b) => a.seconds.compareTo(b.seconds));

      isLoading = false;
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
}
