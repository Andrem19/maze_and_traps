import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mazeandtraps/models/maze_map.dart';
import 'package:mazeandtraps/services/node_stuff.dart';

import '../../models/game_info.dart';
import '../../models/node.dart';
import 'node_widget.dart';

class NodeWidget {
  static Widget getNode(Coordinates Player_A_Coord, Coordinates Player_B_Coord, GameInfo gameInfo, NodeCube nodeProto) {
    return nodeProto.isShaddow
        ? Stack(
            children: [
              Stuff.createBackground(Player_A_Coord, Player_B_Coord, nodeProto, gameInfo),
              Opacity(
                opacity: nodeProto.halfShaddow ? 0.6 : 1,
                child: Container(
                  color: generateColor(),
                ),
              ),
            ],
          )
        : Stuff.createBackground(Player_A_Coord, Player_B_Coord, nodeProto, gameInfo);
  }

  static Color generateColor() {
    Random random = Random();
    int randomInt = random.nextInt(5);
    DateTime now = DateTime.now();
    int rand = now.millisecond;
    Color color = randomInt < 4
        ? Color.fromARGB(255, 24, 22, 23)
        : (rand % 4 == 0
            ? Color.fromARGB(255, 34, 33, 33)
            : rand % 2 == 0
                ? Color.fromARGB(255, 30, 29, 29)
                : rand % 3 == 0
                    ? Color.fromARGB(255, 32, 33, 34)
                    : Color.fromARGB(255, 21, 22, 21));
    return color;
  }
}