import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/battle_act_controller.dart';

import '../../../controllers/main_game_controller.dart';
import '../../../elements/controll.dart';
import '../../../elements/play_material/cube_widget_A.dart';
import '../../../elements/play_material/traps.dart';
import '../../../elements/shell.dart';
import '../../../models/maze_map.dart';
import '../../../services/arrow_direction.dart';

class BattleAct extends StatelessWidget {
  const BattleAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
        content: Scaffold(
      body: GetBuilder<BattleActController>(initState: (state) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom]);
      }, dispose: (state) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }, builder: (controller) {
        final rowLength = controller.mazeMap.value.mazeMap[0].length;
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.mazeMap.value.mazeMap[0].length,
                  childAspectRatio: (kIsWeb
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width) /
                      21 /
                      (MediaQuery.of(context).size.height / 35),
                ),
                itemCount: controller.mazeMap.value.mazeMap.length *
                    controller.mazeMap.value.mazeMap[0].length,
                itemBuilder: (context, index) {
                  final row = index ~/ rowLength;
                  final col = index % rowLength;
                  return Container(
                    height: MediaQuery.of(context).size.height /
                        controller.mazeMap.value.mazeMap.length,
                    child: NodeWidget(
                        playerACoord: controller.mazeMap.value.Player_A_Coord,
                        playerBCoord: controller.yourRole == 'B'
                            ? controller.swapCoordinates(
                                controller.mazeMap.value.Player_B_Coord,
                                controller.mazeWidth,
                                controller.mazeHight)
                            : controller.mazeMap.value.Player_B_Coord,
                        gameInfo: controller.gameInfo.value,
                        nodeProto: controller.mazeMap.value.mazeMap[row][col]),
                  );
                },
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
                  controller.showSkills.value = !controller.showSkills.value;
                  // if (controller.timerDuration == 1200) {
                  //   controller.timerDuration = 600;
                  //   controller.changeStreamInterval(controller.timerDuration);
                  // } else if (controller.timerDuration == 600) {
                  //   controller.timerDuration = 1200;
                  //   controller.changeStreamInterval(controller.timerDuration);
                  // }
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
            controller.showArrowController ? Positioned(bottom: 15, right: 15, child: Control()) : SizedBox(),
          ],
        );
      }),
    ));
  }
}
