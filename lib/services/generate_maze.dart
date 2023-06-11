import 'dart:collection';
import 'dart:core';
import 'dart:math';

import '../models/maze_map.dart';
import '../models/node.dart';

class MazeGenerator {
  static MazeMap createNewMaze(MazeMap mazeMap) {
    List<List<NodeCube>> maze = mazeMap.mazeMap;

    // Set entrance and exit
    maze[34][0].wall = false;
    maze[0][20].wall = false;

    // Set all other cells as walls
    for (int row = 0; row < maze.length; row++) {
      for (int col = 0; col < maze[row].length; col++) {
        if (row != 34 || col != 0) { // Don't overwrite entrance
          if (row != 0 || col != 20) { // Don't overwrite exit
            maze[row][col].wall = true;
          }
        }
      }
    }

    // Add paths to the maze
    Random rand = Random();
    int currRow = rand.nextInt(maze.length);
    int currCol = rand.nextInt(maze[0].length);
    int direction = rand.nextInt(4); // 0:up, 1:down, 2:left, 3:right

    while (true) {
      // Move in current direction for a random number of steps
      int steps = rand.nextInt(10) + 1;
      bool moved = false;
      for (int i = 0; i < steps; i++) {
        switch (direction) {
          case 0: // up
            if (currRow > 0) {
              currRow--;
              moved = true;
            }
            break;
          case 1: // down
            if (currRow < maze.length - 1) {
              currRow++;
              moved = true;
            }
            break;
          case 2: // left
            if (currCol > 0) {
              currCol--;
              moved = true;
            }
            break;
          case 3: // right
            if (currCol < maze[0].length - 1) {
              currCol++;
              moved = true;
            }
            break;
        }
        if (moved) {
          maze[currRow][currCol].wall = false;
        } else {
          break; // Cannot move in this direction anymore
        }
      }

      // Change direction randomly
      direction = rand.nextInt(4);

      // Check if we're near the exit or at a dead end
      if ((currRow == 0 && currCol == 20) || (currRow == 34 && currCol == 0)) {
        // Reached exit or entrance, so stop generating new paths
        break;
      } else if( maze[currRow][currCol].wall == true && getOpenNeighbors(maze, currRow, currCol).isEmpty) {
        // Reached a dead end, so stop generating the current path
        int prevDirection = direction%2 == 0 ? direction + 1 : direction - 1;
        currRow = getNextValidRow(currRow, prevDirection, maze.length);
        currCol = getNextValidCol(currCol, prevDirection, maze[0].length);
        direction = rand.nextInt(4);
      }
    }

    // Make sure there's a path from entrance to exit
    List<NodeCube> path = findPath(maze, maze[34][0], maze[0][20]);
    for (NodeCube node in path) {
      node.wall = false;
    }

    mazeMap.mazeMap = maze;
    return mazeMap;
  }

  static List<int> getOpenNeighbors(List<List<NodeCube>> maze, int row, int col) {
    final neighbors = <int>[];

    if (row > 0 && !maze[row - 1][col].wall) {
      neighbors.add(0);
    }

    if (row < maze.length - 1 && !maze[row + 1][col].wall) {
      neighbors.add(1);
    }

    if (col > 0 && !maze[row][col - 1].wall) {
      neighbors.add(2);
    }

    if (col < maze[row].length - 1 && !maze[row][col + 1].wall) {
      neighbors.add(3);
    }

    return neighbors;
  }

  static int getNextValidRow(int currRow, int direction, int numRows) {
      if (direction == 0) { // Up
          return currRow <= 1 ? currRow + 1 : currRow - 1;
      } else { // Down
          return currRow >= numRows - 2 ? currRow - 1 : currRow + 1;
      }
  }

  static int getNextValidCol(int currCol, int direction, int numCols) {
      if (direction == 2) { // Left
          return currCol <= 1 ? currCol + 1 : currCol - 1;
      } else { // Right
          return currCol >= numCols - 2 ? currCol - 1 : currCol + 1;
      }
  }

  static List<NodeCube> findPath(List<List<NodeCube>> maze, NodeCube start, NodeCube end) {
    final frontier = Queue<NodeCube>();
    final cameFrom = <NodeCube, NodeCube?>{};
    final costSoFar = <NodeCube, double>{};

    frontier.add(start);
    cameFrom[start] = null;
    costSoFar[start] = 0;

    while (frontier.isNotEmpty) {
        final current = frontier.removeLast();

        if (current == end) {
            break;
        }

        for (final next in getNeighbors(maze, current)) {
            final newCost = costSoFar[current]! + 1;

            if (!costSoFar.containsKey(next) || newCost < (costSoFar[next] ?? double.infinity)) {
                costSoFar[next] = newCost;
                frontier.add(next);
                cameFrom[next] = current;
            }
        }
    }

    // Build path
    var path = <NodeCube>[];
    var currentNode = end;
    while (currentNode != start) {
        path.add(currentNode);
        currentNode = cameFrom[currentNode] ?? start; // null-check added
    }
    path.add(start);
    path = path.reversed.toList();

    return path;
}

  static List<NodeCube> getNeighbors(List<List<NodeCube>> maze, NodeCube node) {
    final neighbors = <NodeCube>[];
    final row = node.row;
    final col = node.col;

    if (row > 0 && !maze[row - 1][col].wall) {
      neighbors.add(maze[row - 1][col]);
    }

    if (row < maze.length - 1 && !maze[row + 1][col].wall) {
      neighbors.add(maze[row + 1][col]);
    }

    if (col > 0 && !maze[row][col - 1].wall) {
      neighbors.add(maze[row][col - 1]);
    }

    if (col < maze[row].length - 1 && !maze[row][col + 1].wall) {
      neighbors.add(maze[row][col + 1]);
    }

    return neighbors;
  }

  static double heuristic(NodeCube a, NodeCube b) => ((a.row - b.row).abs() + (a.col - b.col).abs()).toDouble();
}


