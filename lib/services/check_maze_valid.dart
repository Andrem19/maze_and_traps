// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import '../models/node.dart';



class CheckMazeValid {
  static Future<bool> findPath(
      List<List<NodeCube>> grid, int startX, int startY, int endX, int endY) async {
    final visited = [];
    final queue = [grid[startX][startY]];
    while (queue.isNotEmpty) {
      final cube = queue.removeAt(0);
      if (visited.contains(cube)) {
        continue;
      }
      visited.add(cube);
      if (cube.row == endX && cube.col == endY) {
        return true;
      }
      for (final neighbour in getNeighbours(cube.row, cube.col, grid)) {
        if (!neighbour.wall) {
          queue.add(neighbour);
        }
      }
    }
    return false;
  }

  static List<NodeCube> getNeighbours(int x, int y, List<List<NodeCube>> grid) {
    final List<NodeCube> neighbours = [];
    if (x > 0) neighbours.add(grid[x - 1][y]); // add left neighbour
    if (y > 0) neighbours.add(grid[x][y - 1]); // add top neighbour
    if (x < grid.length - 1)
      neighbours.add(grid[x + 1][y]); // add right neighbour
    if (y < grid[0].length - 1)
      neighbours.add(grid[x][y + 1]); // add bottom neighbour
    return neighbours;
  }
}
