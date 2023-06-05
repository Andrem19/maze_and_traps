import 'package:flutter/material.dart';
import 'package:mazeandtraps/elements/play_material/player_A.dart';
import 'package:mazeandtraps/models/maze_map.dart';
import 'package:mazeandtraps/services/create_stuff.dart';
import '../models/game_info.dart';
import '../models/node.dart';
import 'compare_coord.dart';

// class MyStuffWidget extends StatefulWidget {
//   final Coordinates playerACoord;
//   final Coordinates playerBCoord;
//   final NodeCube nodeProto;
//   final GameInfo gameInfo;

//   const MyStuffWidget({
//     Key? key,
//     required this.playerACoord,
//     required this.playerBCoord,
//     required this.nodeProto,
//     required this.gameInfo,
//   }) : super(key: key);

//   @override
//   _MyStuffWidgetState createState() => _MyStuffWidgetState();
// }

// class _MyStuffWidgetState extends State<MyStuffWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Builder(
//           builder: (context) {
//             if (widget.nodeProto.wall) {
//               return Image.asset('assets/images/texture_Wall.png');
//             } else {
//               return Container(
//                 decoration:
//                     widget.nodeProto.is_A_START || widget.nodeProto.is_B_START
//                         ? BoxDecoration(
//                             color: Colors.yellow,
//                             border: Border.all(
//                               width: 2.0,
//                               color: Colors.black12,
//                             ),
//                           )
//                         : 
//                         BoxDecoration(
//                             color: Color.fromARGB(255, 158, 152, 152),
//                             border: Border.all(
//                               width: 2.0,
//                               color: Colors.black12,
//                             ),
//                           ),
//               );
//             }
//           },
//         ),
//         CreateStuffWidget(
//           playerACoord: widget.playerACoord,
//           playerBCoord: widget.playerBCoord,
//           nodeProto: widget.nodeProto,
//           gameInfo: widget.gameInfo,
//         ),
//       ],
//     );
//   }
// }
class MyStuffWidget extends StatefulWidget {
  final Coordinates playerACoord;
  final Coordinates playerBCoord;
  final NodeCube nodeProto;
  final GameInfo gameInfo;
  

  MyStuffWidget({
    Key? key,
    required this.playerACoord,
    required this.playerBCoord,
    required this.nodeProto,
    required this.gameInfo,
  }) : super(key: key);

  @override
  _MyStuffWidgetState createState() => _MyStuffWidgetState();
}

class _MyStuffWidgetState extends State<MyStuffWidget> {
  bool get isWall => widget.nodeProto.wall;

  Widget _buildTile() {
    if (isWall) {
      return Image.asset('assets/images/texture_Wall.png');
    } else {
      return Container(
        decoration:
            widget.nodeProto.is_A_START || widget.nodeProto.is_B_START
                ? yellowBoxDecoration
                : grayBoxDecoration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildTile(),
        CreateStuffWidget(
          playerACoord: widget.playerACoord,
          playerBCoord: widget.playerBCoord,
          nodeProto: widget.nodeProto,
          gameInfo: widget.gameInfo,
        ),
      ],
    );
  }
}
final BoxDecoration yellowBoxDecoration = BoxDecoration(
  color: Colors.yellow,
  border: Border.all(
    width: 2.0,
    color: Colors.black12,
  ),
);

final BoxDecoration grayBoxDecoration = BoxDecoration(
  color: Color.fromARGB(255, 158, 152, 152),
  border: Border.all(
    width: 2.0,
    color: Colors.black12,
  ),
);


