import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/elements/play_material/player_B.dart';
import 'package:mazeandtraps/services/generate_traps.dart';

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
      return getPlayerBasedOnRole(main, myRole, nodeProto, true);
    } else if (Compare.compareCoord(playerBCoord, nodeProto)) {
      return getPlayerBasedOnRole(main, myRole, nodeProto, false);
    } else {
      if (nodeProto.row == 17 &&
          nodeProto.col == 10 &&
          gameInfo.scrolOwner == 'none') {
        return Container(
          child: Image.asset('assets/images/scrolls.png'),
        );
      }

      Widget? widgetToReturn =
          checkIfTrapShouldBeRendered(main, myRole, nodeProto, gameInfo);

      return widgetToReturn ?? SizedBox();
    }
  }

  Widget getPlayerBasedOnRole(MainGameController main, String myRole,
      NodeCube nodeProto, bool isPlayerA) {
    if (main.YourCurrentRole == 'A') {
      return isPlayerA
          ? Player_A.getPlayer(Colors.green, Color(0xFF306D31))
          : !nodeProto.isShaddow
              ? Player_A.getPlayer(Colors.red, Color(0xFF6E1E18))
              : SizedBox();
    } else {
      return !isPlayerA && !nodeProto.isShaddow
          ? Player_B.getPlayer(Colors.green, Color(0xFF306D31))
          : isPlayerA && !nodeProto.isShaddow
              ? Player_B.getPlayer(Colors.red, Color(0xFF6E1E18))
              : SizedBox();
    }
  }

  Widget checkIfTrapShouldBeRendered(MainGameController main, String myRole,
      NodeCube nodeProto, GameInfo gameInfo) {
    if (!nodeProto.isShaddow &&
        !Compare.compareCoord(playerACoord, nodeProto) &&
        !Compare.compareCoord(playerBCoord, nodeProto)) {
      if ((myRole == 'A' &&
              Compare.compareCoord(gameInfo.Teleport_A, nodeProto)) ||
          (myRole == 'B' &&
              Compare.compareCoord(gameInfo.Teleport_B, nodeProto))) {
        return Container(
          child: Image.asset(TrapsGenerator.teleport.img),
        );
      }

      if ((myRole == 'A' &&
              Compare.compareCoord(gameInfo.Frozen_trap_A, nodeProto)) ||
          (myRole == 'B' &&
              Compare.compareCoord(gameInfo.Frozen_trap_B, nodeProto))) {
        return Container(
          child: Image.asset(TrapsGenerator.frozen.img),
        );
      }

      if ((myRole == 'A' && Compare.compareCoord(gameInfo.Bomb_A, nodeProto)) ||
          (myRole == 'B' && Compare.compareCoord(gameInfo.Bomb_B, nodeProto))) {
        return Container(
          child: Image.asset(TrapsGenerator.bomb.img),
        );
      }

      if ((myRole == 'A' &&
              Compare.compareCoord(gameInfo.Knifes_A, nodeProto)) ||
          (myRole == 'B' &&
              Compare.compareCoord(gameInfo.Knifes_B, nodeProto))) {
        return Container(
          child: Image.asset(TrapsGenerator.knife.img),
        );
      }
    }
    return nodeProto.additionalStuff == null 
          ? SizedBox()
          : nodeProto.additionalStuff!();
  }
}
