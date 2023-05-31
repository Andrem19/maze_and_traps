import 'dart:math';

import '../models/maze_map.dart';
import '../models/node.dart';

class TestData {
  static MazeMap createTestMap() {
    int high = 35;
    int width = 21;
    List<List<NodeCube>> maze = List.generate(high, (row) {
      return List.generate(width, (col) {
        bool editA;
        if (row <= high / 2) {
          editA = false;
        } else {
          editA = true;
        }
        return NodeCube(
          editAlowd: editA,
          row: row,
          col: col,
          isShaddow: false,
          halfShaddow: false,
          wall: false,
          is_A_START: false,
          is_B_START: false,
        );
      });
    });
    maze[0][maze[0].length - 1].is_B_START = true;
    maze[maze.length - 1][0].is_A_START = true;
    return MazeMap(
        mazeMap: maze,
        message_A: '',
        message_B: '',
        Player_B_Coord:
            Coordinates(isInit: true, row: 0, col: maze[0].length - 1),
        Player_A_Coord: Coordinates(isInit: true, row: maze.length - 1, col: 0),
        A_FrozenInstalled: false,
        B_FrozenInstalled: false,
        A_DoorInstalled: false,
        B_DoorInstalled: false,
        A_ExitInstalled: false,
        B_ExitInstalled: false,
        Player_A_Frozen: 0,
        Player_B_Frozen: 0,
        DoorTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        DoorTeleport_B: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_A: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_B: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_B: Coordinates(isInit: false, row: 0, col: 0));
  }

  // static List<List<int>> calculateFog() {
  //   List<List<int>> listFog = List.generate(35, (index) {
  //     return List.generate(21, (index) {
  //       int rand = Random().nextInt(50);
  //       return rand;
  //     });
  //   });
  //   return listFog;
  // }

  // static List<List<List<int>>> calc5Fog() {
  //   List<List<List<int>>> setFog = [
  //     [[]]
  //   ];
  //   for (var i = 0; i < 5; i++) {
  //     setFog.add(calculateFog());
  //   }
  //   return setFog;
  // }
}
