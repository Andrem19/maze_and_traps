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
        Player_B_Coord:
            Coordinates(isInit: true, row: 0, col: maze[0].length - 1),
        Player_A_Coord: Coordinates(isInit: true, row: maze.length - 1, col: 0),);
  }
  static MazeMap createStruct(MazeMap mazeMap) {
    double middleHigh = mazeMap.mazeMap.length / 2;
    double middleWidth = mazeMap.mazeMap[0].length / 2;

    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 1][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 1][middleWidth.toInt() + 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() + 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() + 1].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() - 1].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() + 2][middleWidth.toInt() - 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() + 1][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 1][middleWidth.toInt() - 2].wall = true;
    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() - 2].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() - 1].wall = true;

    mazeMap.mazeMap[middleHigh.toInt() - 2][middleWidth.toInt() + 1].wall = true;
    for (var i = 0; i < mazeMap.mazeMap[0].length; i++) {
      mazeMap.mazeMap[middleHigh.toInt()][i].wall = true;
    }
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt()].wall = false;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() + 1].wall = false;
    mazeMap.mazeMap[middleHigh.toInt()][middleWidth.toInt() - 1].wall = false;

    return mazeMap;
  }
}
