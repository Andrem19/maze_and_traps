import 'dart:collection';
import 'dart:core';
import 'dart:math';

import '../models/maze_map.dart';
import '../models/node.dart';


class MazeGenerator {
  static MazeMap createMaze(MazeMap mazeMap) {
    List<List<NodeCube>> grid = mazeMap.mazeMap; // grid.length is 35 grid[0].length is 21
    for (var i = 0; i < grid.length; i++) {
      for (var j = 0; j < grid[i].length; j++) {
        grid[i][j].wall = true;
      }
    }

    // Ensure entrance and exit are free
    grid[34][0].wall = false;
    grid[0][20].wall = false;

    // create path from entrance to center and center to exit
    _createPath(34, 0, 17, 10, grid);
    _createPath(17, 10, 0, 20, grid);

    List<List<int>> path = [];
    Random random = Random();
    int startX = 17;
    int startY = 10;
    _createMaze(startX, startY, grid);
    return mazeMap;
  }

  static void _createMaze(int x, int y, List<List<NodeCube>> grid) {
    grid[x][y].wall = false;
    List<List<int>> neighbors = _getNeighbors(x, y, grid);
    while (neighbors.isNotEmpty) {
      final randomNeighbor = neighbors[Random().nextInt(neighbors.length)];
      int nx = randomNeighbor[0];
      int ny = randomNeighbor[1];
      if (grid[nx][ny].wall == true) {
        grid[nx][ny].wall = false;
        if (nx == x) {
          if (ny > y) {
            grid[x][y + 1].wall = false;
          } else {
            grid[x][y - 1].wall = false;
          }
        }
        if (ny == y) {
          if (nx > x) {
            grid[x + 1][y].wall = false;
          } else {
            grid[x - 1][y].wall = false;
          }
        }
        _createMaze(nx, ny, grid);
      }
      neighbors = _getNeighbors(x, y, grid);
    }
  }

  static List<List<int>> _getNeighbors(
      int x, int y, List<List<NodeCube>> grid) {
    List<List<int>> possibleNeighbors = [
      [x - 2, y],
      [x, y - 2],
      [x + 2, y],
      [x, y + 2]
    ];
    List<List<int>> validNeighbors = [];

    for (int i = 0; i < possibleNeighbors.length; i++) {
      int nx = possibleNeighbors[i][0];
      int ny = possibleNeighbors[i][1];

      if (nx >= 0 &&
          nx < grid.length &&
          ny >= 0 &&
          ny < grid[0].length &&
          grid[nx][ny].wall == true) {
        validNeighbors.add([nx, ny]);
      }
    }
    return validNeighbors;
  }

  static void _createPath(int startX, int startY, int endX, int endY, List<List<NodeCube>> grid) {
    bool isVertical = false;
    if (startY == endY) {
      isVertical = true;
    }

    if (isVertical) {
      int direction = endX > startX ? 1 : -1;
      for (var x = startX; x < endX; x += direction) {
        grid[x][startY].wall = false;
      }
    } else {
      int direction = endY > startY ? 1 : -1;
      for (var y = startY; y < endY; y += direction) {
        grid[startX][y].wall = false;
      }
    }
  }
}

// class MazeGenerator {
//   static MazeMap createMaze(MazeMap mazeMap) {
//     List<List<NodeCube>> grid =
//         mazeMap.mazeMap; // grid.length is 35 grid[0].length is 21
//     for (var i = 0; i < grid.length; i++) {
//       for (var j = 0; j < grid[i].length; j++) {
//         grid[i][j].wall = true;
//       }
//     }
//     List<List<int>> path = [];
//     Random random = Random();
//     int startX = random.nextInt(grid.length);
//     int startY = random.nextInt(grid[0].length);
//     _createMaze(startX, startY, grid);
//     return mazeMap;
//   }

//   static void _createMaze(int x, int y, List<List<NodeCube>> grid) {
//     grid[x][y].wall = false;
//     List<List<int>> neighbors = _getNeighbors(x, y, grid);
//     while (neighbors.isNotEmpty) {
//       final randomNeighbor =
//           neighbors[Random().nextInt(neighbors.length)];
//       int nx = randomNeighbor[0];
//       int ny = randomNeighbor[1];
//       if (grid[nx][ny].wall == true) {
//         grid[nx][ny].wall = false;
//         if (nx == x) {
//           if (ny > y) {
//             grid[x][y + 1].wall = false;
//           } else {
//             grid[x][y - 1].wall = false;
//           }
//         }
//         if (ny == y) {
//           if (nx > x) {
//             grid[x + 1][y].wall = false;
//           } else {
//             grid[x - 1][y].wall = false;
//           }
//         }
//         _createMaze(nx, ny, grid);
//       }
//       neighbors = _getNeighbors(x, y, grid);
//     }
//   }

//   static List<List<int>> _getNeighbors(
//       int x, int y, List<List<NodeCube>> grid) {
//     List<List<int>> possibleNeighbors = [
//       [x - 2, y],
//       [x, y - 2],
//       [x + 2, y],
//       [x, y + 2]
//     ];
//     List<List<int>> validNeighbors = [];

//     for (int i = 0; i < possibleNeighbors.length; i++) {
//       int nx = possibleNeighbors[i][0];
//       int ny = possibleNeighbors[i][1];

//       if (nx >= 0 &&
//           nx < grid.length &&
//           ny >= 0 &&
//           ny < grid[0].length &&
//           grid[nx][ny].wall == true) {
//         validNeighbors.add([nx, ny]);
//       }
//     }
//     return validNeighbors;
//   }
// }
// class MazeGenerator {
//   static MazeMap createMaze(MazeMap mazeMap) {
//     List<List<NodeCube>> grid = mazeMap.mazeMap; // grid.length is 35, grid.length[0].length is 21

//     // Removing border wall
//     for (var i = 1; i < grid.length-1; i++) {
//       for (var j = 1; j < grid[i].length-1; j++) {
//         grid[i][j].wall = true;
//       }
//     }

//     // Placing entrance at maze[34][0]
//     grid[34][0].wall = false;

//     // Placing exit at maze[0][20]
//     grid[0][20].wall = false;

//     List<List<int>> path = [];
//     Random random = Random();
//     int startX = 17;
//     int startY = 10;
//     _createMaze(startX, startY, grid);

//     return mazeMap;
//   }

//   static void _createMaze(int x, int y, List<List<NodeCube>> grid) {
//     List<List<int>> neighbors = _getNeighbors(x, y, grid);
//     while (neighbors.isNotEmpty) {
//       final randomNeighbor =
//           neighbors[Random().nextInt(neighbors.length)];
//       int nx = randomNeighbor[0];
//       int ny = randomNeighbor[1];
//       if (grid[nx][ny].wall == true) {
//         grid[nx][ny].wall = false;

//         // Placing path through the center at maze[17][10]
//         if ((nx == 17 && ny == 11) ||
//             (nx == 16 && ny == 10) ||
//             (nx == 17 && ny == 9) ||
//             (nx == 18 && ny == 10)) {
//           grid[nx][ny].wall = false;
//         }

//         if (nx == x) {
//           if (ny > y) {
//             grid[x][y + 1].wall = false;
//           } else {
//             grid[x][y - 1].wall = false;
//           }
//         }
//         if (ny == y) {
//           if (nx > x) {
//             grid[x + 1][y].wall = false;
//           } else {
//             grid[x - 1][y].wall = false;
//           }
//         }

//         _createMaze(nx, ny, grid);
//       }
//       neighbors = _getNeighbors(x, y, grid);
//     }
//   }

//   static List<List<int>> _getNeighbors(
//       int x, int y, List<List<NodeCube>> grid) {
//     List<List<int>> possibleNeighbors = [
//       [x - 2, y],
//       [x, y - 2],
//       [x + 2, y],
//       [x, y + 2]
//     ];
//     List<List<int>> validNeighbors = [];

//     for (int i = 0; i < possibleNeighbors.length; i++) {
//       int nx = possibleNeighbors[i][0];
//       int ny = possibleNeighbors[i][1];

//       if (nx >= 1 && nx < grid.length - 1 && ny >= 1 && ny < grid[0].length - 1 && grid[nx][ny].wall == true) {
//         validNeighbors.add([nx, ny]);
//       }
//     }
//     return validNeighbors;
//   }
// }




