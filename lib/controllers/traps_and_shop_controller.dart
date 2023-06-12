import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/services/generate_traps.dart';

import '../keys.dart';
import '../models/trap.dart';

class TrapsAndShopController extends GetxController {
  RxInt weight = 10.obs;
  RxInt weightPrice = 2.obs;
  MainGameController main = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    await countWeight();
    super.onInit();
  }

  void allMyTrapsOnAccept(Trap element, Trap data) {
    int indexData = main.allMyTraps.indexWhere((e) => data.name == e.name);
    int indexElement =
        main.allMyTraps.indexWhere((e) => element.name == e.name);
    if (element.name != 'empty') {
      int atIndex = main.allMyTraps.indexOf(element);
      if (indexData != -1) {
        main.allMyTraps[indexData] = element;
        main.allMyTraps[indexElement] = data;
      } else {
        main.allMyTraps.insert(atIndex, data);
        minusWeight(data);
        moveTrapOnTheServer();
      }
      deleteItemFromBackpack(data);
      addLastWhenMoveAllTraps();
      cutLastIfEmptyAllMyTrap();
      cutLastIfEmptyBackpack();
      addLastWhenMoveBackpack();
      main.update();
    } else {
      if (indexData != -1) {
        main.allMyTraps.removeAt(indexData);
      }
      if (indexData == -1) {
        minusWeight(data);
      }
      for (var i = 0; i < main.allMyTraps.length; i++) {
        if (main.allMyTraps[i].name != 'empty') {
          continue;
        } else {
          main.allMyTraps[i] = data;
          deleteItemFromBackpack(data);
          addLastWhenMoveAllTraps();
          cutLastIfEmptyAllMyTrap();
          cutLastIfEmptyBackpack();
          addLastWhenMoveBackpack();
          moveTrapOnTheServer();
          main.update();
          return;
        }
      }
    }
  }

  void backpackOnAccept(Trap element, Trap data) {
    if (main.backpackSet.where((p0) => p0.name != 'empty').toList().length >= 5) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('You can have 5 traps max in the backpack'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    int indexData = main.backpackSet.indexWhere((e) => data.name == e.name);
    int indexElement =
        main.backpackSet.indexWhere((e) => element.name == e.name);
    if (element.name != 'empty') {
      int atIndex = main.backpackSet.indexOf(element);
      if (indexData != -1) {
        main.backpackSet[indexData] = element;
        main.backpackSet[indexElement] = data;
        deleteItemFromAllMyTraps(data);
        addLastWhenMoveAllTraps();
        cutLastIfEmptyAllMyTrap();
        cutLastIfEmptyBackpack();
        addLastWhenMoveBackpack();
      } else {
        if (checkAndRealiseWeight(data)) {
          main.backpackSet.insert(atIndex, data);
          moveTrapOnTheServer();
          deleteItemFromAllMyTraps(data);
          addLastWhenMoveAllTraps();
          cutLastIfEmptyAllMyTrap();
          cutLastIfEmptyBackpack();
          addLastWhenMoveBackpack();
        }
      }
      main.update();
      update();
    } else {
      if (indexData != -1) {
        main.backpackSet.removeAt(indexData);
      }
      for (var i = 0; i < main.backpackSet.length; i++) {
        if (main.backpackSet[i].name != 'empty') {
          continue;
        } else {
          if (checkAndRealiseWeight(data) && indexData == -1) {
            main.backpackSet[i] = data;
            deleteItemFromAllMyTraps(data);
            addLastWhenMoveAllTraps();
            cutLastIfEmptyAllMyTrap();
            cutLastIfEmptyBackpack();
            addLastWhenMoveBackpack();
            moveTrapOnTheServer();
          }
          if (indexData != -1) {
            main.backpackSet[i] = data;
            deleteItemFromAllMyTraps(data);
            addLastWhenMoveAllTraps();
            cutLastIfEmptyAllMyTrap();
            cutLastIfEmptyBackpack();
            addLastWhenMoveBackpack();
          }
          main.update();
          update();
          return;
        }
      }
    }
  }

  void deleteItemFromAllMyTraps(Trap item) {
    main.allMyTraps.remove(item);
  }

  void deleteItemFromBackpack(Trap item) {
    main.backpackSet.remove(item);
  }

  void cutLastIfEmptyAllMyTrap() {
    if (main.allMyTraps.length > 16) {
      if (main.allMyTraps[main.allMyTraps.length - 1].name == 'empty') {
        main.allMyTraps.removeAt(main.allMyTraps.length - 1);
      }
    }
  }

  void cutLastIfEmptyBackpack() {
    if (main.backpackSet.length > 5) {
      if (main.backpackSet[main.backpackSet.length - 1].name == 'empty') {
        main.backpackSet.removeAt(main.backpackSet.length - 1);
      }
    }
  }

  void addLastWhenMoveBackpack() {
    if (main.backpackSet.length >= 5) {
      return;
    } else {
      for (var i = 0; i < 5; i++) {
        Trap trap = Trap(
            id: 0,
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            cost: 0,
            used: false,
            weight: 0);
        main.backpackSet.add(trap);
        if (main.backpackSet.length >= 5) {
          break;
        }
      }
      return;
    }
  }

  void addLastWhenMoveAllTraps() {
    if (main.allMyTraps.length >= 16) {
      return;
    } else {
      for (var i = 0; i < 12; i++) {
        Trap trap = Trap(
            id: 0,
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            cost: 0,
            used: false,
            weight: 0);
        main.allMyTraps.add(trap);
        if (main.allMyTraps.length >= 12) {
          break;
        }
      }
      return;
    }
  }

  void moveTrapOnTheServer() async {
    try {
      var allTraps = TrapsGenerator.toListDynamic(main.allMyTraps);
      var mySetOfTraps = TrapsGenerator.toListDynamic(main.backpackSet);
      await firebaseFirestore
          .collection('users')
          .doc(main.userUid)
          .update({'allTraps': allTraps, 'mySetOfTraps': mySetOfTraps});
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

  void buyTrap(Trap trap) async {
    if (trap.cost <= main.scrolls.value) {
      if (!main.allMyTraps.contains(trap) && !main.backpackSet.contains(trap)) {
        var myAllTraps = TrapsGenerator.toListDynamic(main.allMyTraps);
        myAllTraps.add(trap.name);
        for (var i = 0; i < trap.cost; i++) {
          main.scrollsList.removeLast();
        }
        try {
          await firebaseFirestore
              .collection('users')
              .doc(main.userUid)
              .update({'allTraps': myAllTraps, 'scrolls': main.scrollsList});
          main.authenticate();
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
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text('You already have this trap'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('Not enough scrolls'),
        backgroundColor: Colors.red,
      ));
    }
  }

  bool checkAndRealiseWeight(Trap trap) {
    if (weight.value - trap.weight < 0) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text('Not enough weight in the backpack'),
        backgroundColor: Colors.red,
      ));
      return false;
    } else {
      weight.value -= trap.weight;
      return true;
    }
  }

  void minusWeight(Trap trap) {
    weight.value += trap.weight;
    if (weight.value < 0) {
      weight.value = 0;
    }
    update();
  }

  Future<void> countWeight() async {
    int sum = 0;
    main.backpackSet.forEach((item) {
      sum += item.weight;
    });
    var doc =
        await firebaseFirestore.collection('users').doc(main.userUid).get();
    var data = doc.data();
    int w = data!['weight'];
    List<dynamic> scrols = data['scrolls'];
    int weightP = data['weightPrice'];
    weightPrice.value = weightP;
    main.scrolls.value = scrols.length;
    weight.value = w - sum;
    update();
    main.update();
  }

  void buyWeight() async {
    if (main.scrolls.value >= weightPrice.value) {
      for (var i = 0; i < weightPrice.value; i++) {
        main.scrollsList.removeLast();
      }
      var doc =
          await firebaseFirestore.collection('users').doc(main.userUid).get();
      var data = doc.data();
      int weight = data!['weight'];
      int weightP = data['weightPrice'];
      weightP = (weightP + (weightP / 4)).toInt();
      if (weightP == 3) {
        weightP = 4;
      }
      if (weightP == 2) {
        weightP = 3;
      }

      weight += 1;
      await firebaseFirestore.collection('users').doc(main.userUid).update({
        'scrolls': main.scrollsList,
        'weight': weight,
        'weightPrice': weightP,
      });
      countWeight();
    }
  }
}
