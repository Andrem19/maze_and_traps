import '../models/maze_map.dart';
import '../models/node.dart';

class Compare {
  static bool compareCoord(Coordinates coord, NodeCube node) {
    if (coord.row == node.row && coord.col == node.col && coord.isInit == true) {
      return true;
    }
    return false;
  }
}
