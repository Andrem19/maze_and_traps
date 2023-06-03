import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/map_training_act_controller.dart';
import 'package:mazeandtraps/elements/play_material/traps.dart';
import 'package:mazeandtraps/services/arrow_direction.dart';

import '../../../elements/play_material/cube_widget_A.dart';
import '../../../elements/play_material/node_widget.dart';
import '../../../elements/shell.dart';
import '../../../models/maze_map.dart';

class MapTrainingAct extends StatelessWidget {
  const MapTrainingAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(Scaffold(
      body: GetBuilder<MapTrainingActController>(initState: (state) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom]);
      }, dispose: (state) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }, builder: (controller) {
        return Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(controller.mazeMap.value.mazeMap.length,
                    (row) {
                  return Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                            controller.mazeMap.value.mazeMap[row].length,
                            (col) {
                          return Expanded(
                            child: NodeWidget.getNode(controller.mazeMap.value.Player_A_Coord, controller.mazeMap.value.Player_B_Coord, controller.gameInfo.value,
                                controller.mazeMap.value.mazeMap[row][col]),
                          );
                        })),
                  );
                }),
              ),
            ),
            Center(
                child: Opacity(
                    opacity: 0.6,
                    child: ArrowDir.ArrowDirectionChange(
                        controller.up.value,
                        controller.down.value,
                        controller.left.value,
                        controller.right.value))),
            Row(
              children: [
                Opacity(
                    opacity: 0.5,
                    child: Text(
                      controller.timerText.value,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  controller.textMessage.value,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            GetBuilder<MainGameController>(builder: (main) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () {
                  // controller.showSkills.value = !controller.showSkills.value;
                  if (controller.timerDuration == 1200) {
                    controller.timerDuration = 600;
                    controller.changeTimerDuration();
                  } else if (controller.timerDuration == 600) {
                    controller.timerDuration = 1200;
                    controller.changeTimerDuration();
                  }
                },
                onPanEnd: (DragEndDetails details) {
                  final swipeThreshold = 20;
                  final dx = details.velocity.pixelsPerSecond.dx;
                  final dy = details.velocity.pixelsPerSecond.dy;
                  if (dx.abs() > dy.abs()) {
                    if (dx > swipeThreshold) {
                      main.moveDir = Direction.right;
                      main.playSwipe(dx.toInt());
                      controller.allDirFalse();
                      controller.right.value = true;
                      controller.update();
                      Timer(Duration(milliseconds: 500), () {
                        controller.allDirFalse();
                      });
                    } else if (dx < -swipeThreshold) {
                      main.moveDir = Direction.left;
                      main.playSwipe(dx.toInt());
                      controller.allDirFalse();
                      controller.left.value = true;
                      controller.update();
                      Timer(Duration(milliseconds: 500), () {
                        controller.allDirFalse();
                      });
                    }
                  } else {
                    if (dy < -swipeThreshold) {
                      main.moveDir = Direction.up;
                      main.playSwipe(dx.toInt());
                      controller.allDirFalse();
                      controller.up.value = true;
                      controller.update();
                      Timer(Duration(milliseconds: 500), () {
                        controller.allDirFalse();
                      });
                    } else if (dy > swipeThreshold) {
                      main.moveDir = Direction.down;
                      main.playSwipe(dx.toInt());
                      controller.allDirFalse();
                      controller.down.value = true;
                      controller.update();
                      Timer(Duration(milliseconds: 500), () {
                        controller.allDirFalse();
                      });
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              );
            }),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: controller.showSkills.value ? TrapsShow() : SizedBox(),
            ),
            // Positioned(bottom: 15, right: 15, child: Control()),
          ],
        );
      }),
    ));
  }
}
