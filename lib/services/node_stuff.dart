import 'package:flutter/material.dart';
import 'package:mazeandtraps/elements/play_material/player.dart';
import '../models/game_info.dart';
import '../models/node.dart';
import 'compare_coord.dart';

class Stuff {
  static Widget createBackground(NodeCube nodeProto, GameInfo gameInfo) {
    return Stack(
      children: [
        Builder(builder: (context) {
          if (nodeProto.wall) {
            return Image.asset('assets/images/texture_Wall.png');
            // return FacetedTile();
          } else {
            return Container(
              decoration: nodeProto.is_A_START || nodeProto.is_B_START
                  ? BoxDecoration(
                      color: Colors.yellow,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.black12,
                      ),
                    )
                  : BoxDecoration(
                      color: Color.fromARGB(255, 158, 152, 152),
                      border: Border.all(
                        width: 2.0,
                        color: Colors.black12,
                      ),
                    ),
            );
          }
        }),
        createStuff(nodeProto, gameInfo),
      ],
    );
  }

  static Widget createStuff(NodeCube nodeProto, GameInfo gameInfo) {
    return Builder(
      builder: (context) {
        if (Compare.compareCoord(gameInfo.Player_A_Coord, nodeProto)) {
          return Player.getPlayer(Colors.green, Color.fromARGB(255, 48, 109, 49));
        } else if (Compare.compareCoord(gameInfo.Player_B_Coord, nodeProto)) {
          return Player.getPlayer(Colors.red, Color.fromARGB(255, 110, 30, 24));
        } else {
          if (!nodeProto.isShaddow &&
              !Compare.compareCoord(gameInfo.Player_A_Coord, nodeProto)) {
            if (Compare.compareCoord(gameInfo.Frozen_trap_A, nodeProto) &&
                gameInfo.Frozen_trap_A.isInit) {
              return Container(
                child: Image.asset('assets/images/snowflake.jpg'),
              );
            } else if (Compare.compareCoord(
                    gameInfo.DoorTeleport_A, nodeProto) &&
                gameInfo.DoorTeleport_A.isInit) {
              return Container(
                child: Opacity(
                    opacity: 0.5,
                    child: Image.asset('assets/images/teleport.jpg')),
              );
            } else if (Compare.compareCoord(
                    gameInfo.ExitTeleport_A, nodeProto) &&
                gameInfo.ExitTeleport_A.isInit) {
              return Container(
                child: Opacity(
                    opacity: 0.9,
                    child: Image.asset('assets/images/teleport.jpg')),
              );
            }
            return SizedBox();
          }
        }
        return SizedBox();
      },
    );
  }
}
