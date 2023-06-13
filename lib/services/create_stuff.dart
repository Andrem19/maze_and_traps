import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/elements/play_material/player_B.dart';

import '../elements/play_material/player_A.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import '../models/node.dart';
import 'compare_coord.dart';
class CreateStuffWidget extends StatelessWidget {
  final double opacityValue = 0.7;
  final Coordinates playerACoord;
  final Coordinates playerBCoord;
  final NodeCube nodeProto;
  final GameInfo gameInfo;

  const CreateStuffWidget({
    Key? key,
    required this.playerACoord,
    required this.playerBCoord,
    required this.nodeProto,
    required this.gameInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var main = Get.find<MainGameController>();
    String myRole = main.YourCurrentRole.value;
    if (Compare.compareCoord(playerACoord, nodeProto)) {
      if (main.YourCurrentRole == 'A') {
        return Player_A.getPlayer(Colors.green, Color(0xFF306D31));
      } else {
        if (!nodeProto.isShaddow) {
          return Player_A.getPlayer(Colors.red, Color(0xFF6E1E18));
        }
      }
    } else if (Compare.compareCoord(playerBCoord, nodeProto)) {
      if (main.YourCurrentRole == 'A') {
        if (!nodeProto.isShaddow) {
          return Player_B.getPlayer(Colors.red, Color(0xFF6E1E18));
        }
      } else {
        return Player_B.getPlayer(Colors.green, Color(0xFF306D31));
      }
    } else {
      if (nodeProto.row == 17 && nodeProto.col == 10 && gameInfo.scrolOwner == 'none') {
        return Container(
            child: Image.asset('assets/images/scrolls.png'),
          );
      }
      if (!nodeProto.isShaddow &&
          !Compare.compareCoord(playerACoord, nodeProto)) {
        if ((myRole == 'A' && Compare.compareCoord(gameInfo.Frozen_trap_A, nodeProto)) ||
            (myRole == 'B' && Compare.compareCoord(gameInfo.Frozen_trap_B, nodeProto))) {
          return Container(
            child: Image.asset('assets/images/trap_Icons/texture_FrostTrap.png'),
          );
        } 
        return SizedBox();
      }
    }
    return SizedBox();
  }
}


// class CreateStuffWidget extends StatelessWidget {
//   final Coordinates playerACoord;
//   final Coordinates playerBCoord;
//   final NodeCube nodeProto;
//   final GameInfo gameInfo;

//   const CreateStuffWidget({
//     Key? key,
//     required this.playerACoord,
//     required this.playerBCoord,
//     required this.nodeProto,
//     required this.gameInfo,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var main = Get.find<MainGameController>();
//     String myRole = main.YourCurrentRole;
//     if (Compare.compareCoord(playerACoord, nodeProto)) {
//       if (main.YourCurrentRole == 'A') {
//         return Player_A.getPlayer(Colors.green, Color(0xFF306D31));
//       } else {
//         if (!nodeProto.isShaddow) {
//           return Player_A.getPlayer(Colors.red, Color(0xFF6E1E18));
//         }
//       }
//     } else if (Compare.compareCoord(playerBCoord, nodeProto)) {
//       if (main.YourCurrentRole == 'A') {
//         if (!nodeProto.isShaddow) {
//           return Player_B.getPlayer(Colors.red, Color(0xFF6E1E18));
//         }
//       } else {
//         return Player_B.getPlayer(Colors.green, Color(0xFF306D31));
//       }
//     } else {
//       if (!nodeProto.isShaddow &&
//           !Compare.compareCoord(playerACoord, nodeProto)) {
//         if (Compare.compareCoord(gameInfo.Frozen_trap_A, nodeProto) &&
//             gameInfo.Frozen_trap_A.isInit) {
//           return Container(
//             child:
//                 Image.asset('assets/images/trap_Icons/texture_FrostTrap.png'),
//           );
//         } 
//         return SizedBox();
//       }
//     }
//     return SizedBox();
//   }
// }
