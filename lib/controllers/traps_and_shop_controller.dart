import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/services/generate_traps.dart';

import '../keys.dart';
import '../models/trap.dart';

class TrapsAndShopController extends GetxController {
  RxInt weight = 10.obs;
  MainGameController main = Get.find<MainGameController>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    countWeight();
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
    if (main.allMyTraps.length > 12) {
      if (main.allMyTraps[main.allMyTraps.length - 1].name == 'empty') {
        main.allMyTraps.removeAt(main.allMyTraps.length - 1);
      }
    }
  }

  void cutLastIfEmptyBackpack() {
    if (main.backpackSet.length > 12) {
      if (main.backpackSet[main.backpackSet.length - 1].name == 'empty') {
        main.backpackSet.removeAt(main.backpackSet.length - 1);
      }
    }
  }

  void addLastWhenMoveBackpack() {
    if (main.backpackSet.length >= 12) {
      return;
    } else {
      for (var i = 0; i < 12; i++) {
        Trap trap = Trap(
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            cost: 0,
            weight: 0);
        main.backpackSet.add(trap);
        if (main.backpackSet.length >= 12) {
          break;
        }
      }
      return;
    }
  }

  void addLastWhenMoveAllTraps() {
    if (main.allMyTraps.length >= 12) {
      return;
    } else {
      for (var i = 0; i < 12; i++) {
        Trap trap = Trap(
            name: 'empty',
            description: '',
            damage: 0,
            baff: 0,
            img: '',
            cost: 0,
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

  void countWeight() {
    int sum = 0;
    main.backpackSet.forEach((item) {
      sum += item.weight;
    });
    weight.value = 10 - sum;
  }

  // void testScrolls() async {
  //   var doc = await firebaseFirestore
  //       .collection('wisdomScrolls')
  //       .doc('TO3pay0R0byjSLMinIXq')
  //       .get();

  //   var data = doc.data();
  //   var listOfScrolls = data!['listOfScrolls'] as List<dynamic>;
  //   for (var i = 0; i < listOfScrolls.length; i++) {
  //     print(listOfScrolls[i]);
  //   }
  //   listOfScrolls.add('test test test');
  //   await firebaseFirestore
  //       .collection('wisdomScrolls')
  //       .doc('TO3pay0R0byjSLMinIXq')
  //       .update({'listOfScrolls': listOfScrolls});
  // }
}
