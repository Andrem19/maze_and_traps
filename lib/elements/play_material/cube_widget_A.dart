// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mazeandtraps/models/maze_map.dart';
import 'package:mazeandtraps/services/node_stuff.dart';

import '../../models/game_info.dart';
import '../../models/node.dart';
import 'node_widget.dart';

class NodeWidget extends StatefulWidget {
  final Coordinates playerACoord;
  final Coordinates playerBCoord;
  final GameInfo gameInfo;
  final NodeCube nodeProto;
  static final Random _random = Random();
  static const List<Color> _preGeneratedColors = [
    Color(0xFF181617),
    Color(0xFF1E1D1D),
    Color(0xFF202122),
    Color(0xFF151617),
  ];

  const NodeWidget({
    Key? key,
    required this.playerACoord,
    required this.playerBCoord,
    required this.gameInfo,
    required this.nodeProto,
  }) : super(key: key);

  static Color generateColor() {
    int randomInt = _random.nextInt(50);
    return randomInt < 40
        ? _preGeneratedColors[0]
        : (randomInt % 4 == 0
            ? _preGeneratedColors[1]
            : randomInt % 2 == 0
                ? _preGeneratedColors[2]
                : _preGeneratedColors[3]);
  }

  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  Widget? _myStuffWidget;

  @override
  Widget build(BuildContext context) {
    Widget newWidget;
    if (widget.nodeProto.isShaddow) {
      newWidget = widget.nodeProto.halfShaddow
          ? Visibility(
              visible: _myStuffWidget != null,
              maintainState: true,
              child: _myStuffWidget ??= MyStuffWidget(
                playerACoord: widget.playerACoord,
                playerBCoord: widget.playerBCoord,
                nodeProto: widget.nodeProto,
                gameInfo: widget.gameInfo,
              ))
          : const SizedBox();
      newWidget = Stack(
        children: [
          newWidget,
          Opacity(
            opacity: widget.nodeProto.halfShaddow ? 0.7 : 1,
            child: Container(
              color: NodeWidget.generateColor(),
            ),
          )
        ],
      );
    } else {
      _myStuffWidget = MyStuffWidget(
              playerACoord: widget.playerACoord,
              playerBCoord: widget.playerBCoord,
              nodeProto: widget.nodeProto,
              gameInfo: widget.gameInfo,
            );
            return _myStuffWidget!;
    }
    return newWidget;
  }
}
