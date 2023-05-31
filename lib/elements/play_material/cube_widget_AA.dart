import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mazeandtraps/services/node_stuf.dart';

import '../../models/game_info.dart';
import '../../models/node.dart';

class Cube_Widget_AA extends StatelessWidget {
  GameInfo gameInfo;
  NodeCube nodeProto;
  Cube_Widget_AA({
    Key? key,
    required this.nodeProto,
    required this.gameInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int randomInt = Random().nextInt(5);
    DateTime now = DateTime.now();
    int rand = now.millisecond;
    // int rand = 4;
    return nodeProto.isShaddow
        ? Stack(
            children: [
              Stuff.createBackground(nodeProto, gameInfo),
              Opacity(
                opacity: nodeProto.halfShaddow ? 0.6 : 1,
                child: Container(
                  color: randomInt==0 || randomInt==1 || randomInt==2 || randomInt==3 ?Color.fromARGB(255, 24, 22, 23) : (rand % 4 == 0
                      ? Color.fromARGB(255, 34, 33, 33)
                      : rand % 2 == 0
                          ? Color.fromARGB(255, 30, 29, 29)
                          : rand % 3 == 0
                              ? Color.fromARGB(255, 32, 33, 34)
                              : Color.fromARGB(255, 21, 22, 21)),
                ),
              ),
            ],
          )
        : Stuff.createBackground(nodeProto, gameInfo);
  }
}
