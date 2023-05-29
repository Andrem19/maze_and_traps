import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../keys.dart';
import '../models/champions copy.dart';
import '../models/leaders copy.dart';

class LeadersController extends GetxController {
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxList<Leaders> leaders = [Leaders(name: 'nobody', points: 0)].obs;

  @override
  void onInit() async {
    await loadLeaders();
    super.onInit();
  }

  Future<void> loadLeaders() async {
    isLoading = true;
    try {
      var data = await firebaseFirestore
          .collection('users')
          .orderBy('points', descending: true)
          .limit(100)
          .get();
      if (data.docs.length > 0) {
        var docs = data.docs;
        leaders.value.clear();
        for (var i = 0; i < docs.length; i++) {
          var username = docs[i]['name'];
          var points = docs[i]['points'];
          leaders.value.add(Leaders(name: username, points: points));
        }
        update();
        isLoading = false;
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('No leaders yet'),
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
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}
