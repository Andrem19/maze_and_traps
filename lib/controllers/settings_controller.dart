import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../keys.dart';

class SettingsController extends GetxController {
  MainGameController mainCtrl = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late SharedPreferences pref;
  Rx<TextEditingController> migrationToken = TextEditingController().obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<String> migrationTokenGen = ''.obs;

  @override
  void onInit() async {
    userNameController.value.text = mainCtrl.userName.value;
    update();
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  void generateMigrationToken() async {
    await mainCtrl.checkUserAuth();
    String utoken = uuid.v4();

    await Clipboard.setData(ClipboardData(text: utoken));
    migrationTokenGen.value = utoken;
    try {
      await firebaseFirestore.collection('users').doc(mainCtrl.userUid).update({
        'migrationToken': utoken,
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
    Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('Token was copied'),
      backgroundColor: Color.fromARGB(255, 54, 244, 67),
    ));
    update();
  }

  Future<void> updateName() async {
    String normalizedName =
        userNameController.value.text.replaceAll(RegExp(r'\s+'), '');
    await mainCtrl.checkUserAuth();
    bool res = await mainCtrl.chekNameExist(normalizedName);
    if (res) {
      return;
    }
    try {
      mainCtrl.userName.value = normalizedName;
      var user = await firebaseFirestore
          .collection('users')
          .doc(mainCtrl.userUid)
          .get();
      if (user.exists) {
        await firebaseFirestore
            .collection('users')
            .doc(mainCtrl.userUid)
            .update({
          'name': normalizedName,
        });
        update();
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Name updated'),
          backgroundColor: Color.fromARGB(255, 54, 244, 67),
        ));
        Get.offNamed(Routes.GENERAL_MENU);
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('User does not auth'),
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

  Future<void> migrate() async {
    try {
      var document = await firebaseFirestore
          .collection('users')
          .where('migrationToken', isEqualTo: migrationToken.value.text)
          .get();
      if (document.docs.isEmpty) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(
              'No token in database.\nPlease generate new token on your account you want to transfer'),
          backgroundColor: Colors.red,
        ));
      }
      if (!document.docs[0].exists) {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text(
              'No token in database.\nPlease generate new token on your account you want to transfer'),
          backgroundColor: Colors.red,
        ));
      }

      String userName = document.docs[0]['name'];
      String secT = document.docs[0]['secretToken'];
      String uid = document.docs[0]['uid'];
      pref.setString('secretToken', secT);
      pref.setString('uid', uid);
      await mainCtrl.authenticate();
      Get.offNamed(Routes.GENERAL_MENU);
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
