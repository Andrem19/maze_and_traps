import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_game_controller.dart';
import '../../models/game_info.dart';
import '../../models/node.dart';
import '../../services/compare_coord.dart';
import '../brick.dart';

class CubeBrick_A extends StatelessWidget {
  GameInfo gameInfo;
  NodeCube nodeProto;
  CubeBrick_A({
    Key? key,
    required this.nodeProto,
    required this.gameInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (nodeProto.isShaddow) {
      return GetBuilder<MainGameController>(builder: (controller) {
        int rand = Random().nextInt(50);
        return Container(
          color: rand % 4 == 0
              ? Color.fromARGB(255, 60, 58, 58)
              : rand % 2 == 0
                  ? Color.fromARGB(255, 48, 44, 44)
                  : rand % 3 == 0
                      ? Color.fromARGB(255, 59, 61, 65)
                      : Color.fromARGB(255, 39, 42, 39),
        );
      });
    } else {
      if (nodeProto.wall) {
        return Image.asset('assets/images/texture_Wall.png');
      } else if (nodeProto.is_B_START || nodeProto.is_A_START) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
              width: 2.0,
              color: Colors.black12,
            ),
          ),
          child: createStuff(nodeProto),
        );
      } else {
        return Container(
          child: createStuff(nodeProto),
          decoration: BoxDecoration(
            color: Colors.white30,
            border: Border.all(
              width: 2.0,
              color: Colors.black12,
            ),
          ),
        );
      }
    }
  }

  Container? createStuff(NodeCube nodeProto) {
    if (Compare.compareCoord(gameInfo.Player_A_Coord, nodeProto)) {
      if (Compare.compareCoord(gameInfo.Frozen_trap_B, nodeProto)) {
        return Container(
          child: Image.asset('assets/images/snowflake.jpg'),
        );
      }
      return Container(
        decoration: new BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      );
    } else if (Compare.compareCoord(gameInfo.Player_B_Coord, nodeProto)) {
      return Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      if (!nodeProto.isShaddow &&
          !Compare.compareCoord(gameInfo.Player_A_Coord, nodeProto)) {
        if (Compare.compareCoord(gameInfo.Frozen_trap_A, nodeProto) &&
            gameInfo.Frozen_trap_A.isInit) {
          return Container(
            child: Image.asset('assets/images/snowflake.jpg'),
          );
        } else if (Compare.compareCoord(gameInfo.DoorTeleport_A, nodeProto) &&
            gameInfo.DoorTeleport_A.isInit) {
          return Container(
            child: Opacity(
                opacity: 0.5, child: Image.asset('assets/images/teleport.jpg')),
          );
        } else if (Compare.compareCoord(gameInfo.ExitTeleport_A, nodeProto) &&
            gameInfo.ExitTeleport_A.isInit) {
          return Container(
            child: Opacity(
                opacity: 0.9, child: Image.asset('assets/images/teleport.jpg')),
          );
        }
      }
    }
  }
}
