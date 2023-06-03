import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_info.dart';
import '../../models/maze_map.dart';
import '../../models/node.dart';
import '../../services/node_stuff.dart';

class BackgroundWidget extends StatefulWidget {
  final NodeCube nodeProto;
  final GameInfo gameInfo;
  final Coordinates Player_A_Coord;
  final Coordinates Player_B_Coord;

  BackgroundWidget({required this.Player_A_Coord, required this.Player_B_Coord, required this.nodeProto, required this.gameInfo});

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _backgroundColor = _calculateBackgroundColor();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(backgroundColor: _backgroundColor),
      child: Container(
        child: Stuff.createBackground(widget.Player_A_Coord, widget.Player_B_Coord, widget.nodeProto, widget.gameInfo),
      ),
    );
  }

  Color _calculateBackgroundColor() {
    final randomInt = Random().nextInt(10);
    final rand = Random().nextInt(5);

    return randomInt < 4
        ? Color.fromARGB(255, 24, 22, 23)
        : (rand % 4 == 0
            ? Color.fromARGB(255, 34, 33, 33)
            : rand % 2 == 0
                ? Color.fromARGB(255, 30, 29, 29)
                : rand % 3 == 0
                    ? Color.fromARGB(255, 32, 33, 34)
                    : Color.fromARGB(255, 21, 22, 21));
  }
}

class BackgroundPainter extends CustomPainter {
  final Color backgroundColor;

  BackgroundPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
