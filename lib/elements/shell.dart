import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/main_game_controller.dart';
import '../controllers/map_training_act_controller.dart';
import '../models/maze_map.dart';

class Shell {
  static Widget getShell(Widget content) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: Center(
          child: Container(
            decoration: kIsWeb
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 72, 68, 68),
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 3),
                    ],
                  )
                : const BoxDecoration(),
            width: kIsWeb ? Get.size.width / 3 : Get.size.width,
            // child: kIsWeb ? RawKeyboardListener(
            //           focusNode: new FocusNode(),
            //           onKey: _handleKeyEvent,
            //           child: content) :
                child: content,
          ),
        ),
      );
    });
  }

//   static void _handleKeyEvent(RawKeyEvent event) {
//     var main = Get.find<MainGameController>();
//     var controller = Get.find<MapTrainingActController>();
//     int rand = Random().nextInt(50);

//   if (event.runtimeType == RawKeyUpEvent) {
//     return;
//   }

//   switch (event.logicalKey.keyLabel) {
//     case 'A':
//       main.moveDir = Direction.left;
//       main.playSwipe(rand);
//       controller.allDirFalse();
//       controller.left.value = true;
//       controller.update();
//       Timer(Duration(milliseconds: 500), () {
//         controller.allDirFalse();
//       });
//       break;
//     case 'W':
//       main.moveDir = Direction.up;
//       main.playSwipe(rand);
//       controller.allDirFalse();
//       controller.up.value = true;
//       controller.update();
//       Timer(Duration(milliseconds: 500), () {
//         controller.allDirFalse();
//       });
//       break;
//     case 'D':
//       main.moveDir = Direction.right;
//       main.playSwipe(rand);
//       controller.allDirFalse();
//       controller.right.value = true;
//       controller.update();
//       Timer(Duration(milliseconds: 500), () {
//         controller.allDirFalse();
//       });
//       break;
//     case 'S':
//       main.moveDir = Direction.down;
//       main.playSwipe(rand);
//       controller.allDirFalse();
//       controller.down.value = true;
//       controller.update();
//       Timer(Duration(milliseconds: 500), () {
//         controller.allDirFalse();
//       });
//       break;
//     default:
//       break;
//   }
// }
}
