import 'package:flutter/material.dart';

import '../elements/play_material/player.dart';
import '../models/game_info.dart';
import '../models/maze_map.dart';
import '../models/node.dart';
import 'compare_coord.dart';

class CreateStuffWidget extends StatelessWidget {
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
    if (Compare.compareCoord(playerACoord, nodeProto)) {
      return Player.getPlayer(Colors.green, Color(0xFF306D31));

    } else if (Compare.compareCoord(playerBCoord, nodeProto)) {
      return Player.getPlayer(Colors.red, Color(0xFF6E1E18));

    } else {
      if (!nodeProto.isShaddow &&
          !Compare.compareCoord(playerACoord, nodeProto)) {
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
        return SizedBox();
      }
    }
    return SizedBox();
  }
}
