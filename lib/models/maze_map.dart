// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import 'game_info.dart';
import 'node.dart';

enum Direction { up, down, left, right }

class MazeMap {
  List<List<NodeCube>> mazeMap;
  String message_A;
  String message_B;
  Coordinates Player_A_Coord;
  Coordinates Player_B_Coord;
  MazeMap({
    required this.mazeMap,
    required this.message_A,
    required this.message_B,
    required this.Player_A_Coord,
    required this.Player_B_Coord,
  });

  void reverse() {
    String tempMessage = message_A;
    message_A = message_B;
    message_B = tempMessage;

    Coordinates tempCoords = Player_A_Coord;
    Player_A_Coord = Player_B_Coord;
    Player_B_Coord = tempCoords;

    mazeMap = mazeMap.reversed.toList();
    for (var i = 0; i < mazeMap.length; i++) {
      mazeMap[i] = mazeMap[i].reversed.toList();
      for (var j = 0; j < mazeMap[i].length; j++) {}
    }
  }

  MazeMap reversePlus() {
    Player_B_Coord = Coordinates(
        isInit: Player_B_Coord.isInit,
        row: (mazeMap.length - 1) - Player_B_Coord.row,
        col: (mazeMap[0].length - 1) - Player_B_Coord.col);
    Player_A_Coord = Coordinates(
        isInit: Player_A_Coord.isInit,
        row: (mazeMap.length - 1) - Player_A_Coord.row,
        col: (mazeMap[0].length - 1) - Player_A_Coord.col);
    mazeMap = mazeMap.reversed.toList();
    for (var i = 0; i < mazeMap.length; i++) {
      mazeMap[i] = mazeMap[i].reversed.toList();
      for (var j = 0; j < mazeMap[i].length; j++) {}
    }
    return this;
  }

  double calculateDistance() {
    int numRows = mazeMap.length;
    int numCols = mazeMap[0].length;

    int player1Row = Player_A_Coord.row;
    int player1Col = Player_A_Coord.col;
    int player2Row = Player_B_Coord.row;
    int player2Col = Player_B_Coord.col;

    double distance =
        sqrt(pow(player2Row - player1Row, 2) + pow(player2Col - player1Col, 2));

    return distance;
  }

  void countRadiusAroundPlayer_A(int shaddowRadius, bool withBorder) {
    mazeMap.forEach((row) => row.forEach((node) => node.isShaddow = true));
    int startRow = Player_A_Coord.row - shaddowRadius - 1 < 0
        ? 0
        : Player_A_Coord.row - shaddowRadius - 1;
    int endRow = Player_A_Coord.row + shaddowRadius + 1 >= mazeMap.length
        ? mazeMap.length - 1
        : Player_A_Coord.row + shaddowRadius + 1;
    int startCol = Player_A_Coord.col - shaddowRadius - 1 < 0
        ? 0
        : Player_A_Coord.col - shaddowRadius - 1;
    int endCol = Player_A_Coord.col + shaddowRadius + 1 >= mazeMap[0].length
        ? mazeMap[0].length - 1
        : Player_A_Coord.col + shaddowRadius + 1;
    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        double distance = sqrt(pow(Player_A_Coord.row - row, 2) +
            pow(Player_A_Coord.col - col, 2));
        if (distance <= shaddowRadius) {
          mazeMap[row][col].isShaddow = false;
        } else if (withBorder &&
            distance > shaddowRadius &&
            distance <= shaddowRadius + 1) {
          mazeMap[row][col].halfShaddow = true;
        }
      }
    }
  }

  void countRadiusAroundPlayer_B(int shaddowRadius, bool withBorder) {
    mazeMap.forEach((row) => row.forEach((node) => node.isShaddow = true));
    int startRow = Player_B_Coord.row - shaddowRadius - 1 < 0
        ? 0
        : Player_B_Coord.row - shaddowRadius - 1;
    int endRow = Player_B_Coord.row + shaddowRadius + 1 >= mazeMap.length
        ? mazeMap.length - 1
        : Player_B_Coord.row + shaddowRadius + 1;
    int startCol = Player_B_Coord.col - shaddowRadius - 1 < 0
        ? 0
        : Player_B_Coord.col - shaddowRadius - 1;
    int endCol = Player_B_Coord.col + shaddowRadius + 1 >= mazeMap[0].length
        ? mazeMap[0].length - 1
        : Player_B_Coord.col + shaddowRadius + 1;
    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        double distance = sqrt(pow(Player_B_Coord.row - row, 2) +
            pow(Player_B_Coord.col - col, 2));
        if (distance <= shaddowRadius) {
          mazeMap[row][col].isShaddow = false;
        } else if (withBorder &&
            distance > shaddowRadius &&
            distance <= shaddowRadius + 1) {
          mazeMap[row][col].halfShaddow = true;
        }
      }
    }
  }

  bool MovePlayer_A(Direction direction, GameInfo gameInfo) {
    if (gameInfo.Player_A_Frozen != 0) {
      gameInfo.Player_A_Frozen -= 1;
      return false;
    }
    message_A = '';
    switch (direction) {
      case Direction.up:
        if (Player_A_Coord.row != 0) {
          if (!mazeMap[Player_A_Coord.row - 1][Player_A_Coord.col].wall) {
            Player_A_Coord.row -= 1;
          }
        }
        break;
      case Direction.down:
        if (Player_A_Coord.row != mazeMap.length - 1) {
          if (!mazeMap[Player_A_Coord.row + 1][Player_A_Coord.col].wall) {
            Player_A_Coord.row += 1;
          }
        }
        break;
      case Direction.left:
        if (Player_A_Coord.col != 0) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col - 1].wall) {
            Player_A_Coord.col -= 1;
          }
        }
        break;
      case Direction.right:
        if (Player_A_Coord.col != mazeMap[0].length - 1) {
          if (!mazeMap[Player_A_Coord.row][Player_A_Coord.col + 1].wall) {
            Player_A_Coord.col += 1;
          }
        }
        break;
      default:
    }

    if (gameInfo.Frozen_trap_B.row == Player_A_Coord.row &&
        gameInfo.Frozen_trap_B.col == Player_A_Coord.col) {
      gameInfo.Player_A_Frozen = 8;
      FlameAudio.play('freeze.wav');
      message_B = 'Player was frozen';
    }

    if (gameInfo.DoorTeleport_B.row == Player_A_Coord.row &&
        gameInfo.DoorTeleport_B.col == Player_A_Coord.col &&
        gameInfo.ExitTeleport_B.isInit) {
      Player_A_Coord.row = gameInfo.ExitTeleport_B.row;
      Player_A_Coord.col = gameInfo.ExitTeleport_B.col;
      message_A = 'Teleport trap';
      FlameAudio.play('teleport.mp3');
      gameInfo.ExitTeleport_B.isInit = false;
      return true;
    }
    return false;
  }

  bool MovePlayer_B(Direction direction, GameInfo gameInfo) {
    if (gameInfo.Player_B_Frozen != 0) {
      gameInfo.Player_B_Frozen -= 1;
      return false;
    }
    message_B = '';
    switch (direction) {
      case Direction.up:
        if (Player_B_Coord.row != 0) {
          if (!mazeMap[Player_B_Coord.row - 1][Player_B_Coord.col].wall) {
            Player_B_Coord.row -= 1;
          }
        }
        break;
      case Direction.down:
        if (Player_B_Coord.row != mazeMap.length - 1) {
          if (!mazeMap[Player_B_Coord.row + 1][Player_B_Coord.col].wall) {
            Player_B_Coord.row += 1;
          }
        }
        break;
      case Direction.left:
        if (Player_B_Coord.col != 0) {
          if (!mazeMap[Player_B_Coord.row][Player_B_Coord.col - 1].wall) {
            Player_B_Coord.col -= 1;
          }
        }
        break;
      case Direction.right:
        if (Player_B_Coord.col != mazeMap[0].length - 1) {
          if (!mazeMap[Player_B_Coord.row][Player_B_Coord.col + 1].wall) {
            Player_B_Coord.col += 1;
          }
        }
        break;
      default:
    }
    if (gameInfo.Frozen_trap_A.row == Player_B_Coord.row &&
        gameInfo.Frozen_trap_A.col == Player_B_Coord.col) {
      gameInfo.Player_B_Frozen = 8;
      FlameAudio.play('freeze.wav');
      message_B = 'Player was frozen';
    }

    if (gameInfo.DoorTeleport_A.row == Player_B_Coord.row &&
        gameInfo.DoorTeleport_A.col == Player_B_Coord.col &&
        gameInfo.ExitTeleport_A.isInit) {
      Player_B_Coord.row = gameInfo.ExitTeleport_A.row;
      Player_B_Coord.col = gameInfo.ExitTeleport_A.col;
      message_B = 'Teleport trap';
      FlameAudio.play('teleport.mp3');
      gameInfo.ExitTeleport_A.isInit = false;
      return true;
    }
    return false;
  }

  bool checkTheFinish_A() {
    if (Player_A_Coord.row == 0 &&
        Player_A_Coord.col == mazeMap[0].length - 1) {
      return true;
    }
    return false;
  }

  bool checkTheFinish_B() {
    if (Player_B_Coord.row == 0 &&
        Player_B_Coord.col == mazeMap[0].length - 1) {
      return true;
    }
    return false;
  }

  // void instalFrozen_A() {
  //   if (!A_FrozenInstalled) {
  //     Frozen_trap_A = Coordinates(
  //         isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
  //     A_FrozenInstalled = true;
  //     message_A = 'Frozen trap instaled';
  //     FlameAudio.play('freeze.wav');
  //   }
  // }

  // void instalDoor_A() {
  //   if (!A_DoorInstalled) {
  //     DoorTeleport_A = Coordinates(
  //         isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
  //     A_DoorInstalled = true;
  //     message_A = 'Door trap instaled';
  //   }
  // }

  // void instalExit_A() {
  //   if (!A_ExitInstalled && A_DoorInstalled) {
  //     A_ExitInstalled = true;
  //     ExitTeleport_A = Coordinates(
  //         isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
  //     message_A = 'Exit trap instaled';
  //   } else {
  //     message_A = 'first you should to install the door';
  //   }
  // }

  // void instalFrozen_B() {
  //   if (!B_FrozenInstalled) {
  //     Frozen_trap_B = Coordinates(
  //         isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
  //     B_FrozenInstalled = true;
  //     message_B = 'Frozen trap instaled';
  //     FlameAudio.play('freeze.wav');
  //   }
  // }

  // void instalDoor_B() {
  //   if (!B_DoorInstalled) {
  //     DoorTeleport_B = Coordinates(
  //         isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
  //     B_DoorInstalled = true;
  //     message_B = 'Door trap instaled';
  //   }
  // }

  // void instalExit_B() {
  //   if (!B_ExitInstalled && B_DoorInstalled) {
  //     B_ExitInstalled = true;
  //     ExitTeleport_B = Coordinates(
  //         isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
  //     message_B = 'Exit trap instaled';
  //   } else {
  //     message_B = 'first you should to install the door';
  //   }
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mazeMap': mazeMap.asMap().map((key, value) {
        return MapEntry(
            key.toString(),
            value.asMap().map((k, v) {
              return MapEntry(k.toString(), v.toMap());
            }));
      }),
      'message_A': message_A,
      'message_B': message_B,
      'Player_A_Coord': Player_A_Coord.toMap(),
      'Player_B_Coord': Player_B_Coord.toMap(),
    };
  }

  factory MazeMap.fromMap(Map<String, dynamic> map) {
    return MazeMap(
      mazeMap: List<List<NodeCube>>.from(map['mazeMap'].entries.map(
            (entry) => List<NodeCube>.from(
                entry.value.entries.map((e) => NodeCube.fromMap(e.value))),
          )),
      message_A: map['message_A'] as String,
      message_B: map['message_B'] as String,
      Player_A_Coord:
          Coordinates.fromMap(map['Player_A_Coord'] as Map<String, dynamic>),
      Player_B_Coord:
          Coordinates.fromMap(map['Player_B_Coord'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MazeMap.fromJson(String source) =>
      MazeMap.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Coordinates {
  bool isInit;
  int row;
  int col;
  Coordinates({
    required this.isInit,
    required this.row,
    required this.col,
  });

  Coordinates copyWith({
    bool? isInit,
    int? row,
    int? col,
  }) {
    return Coordinates(
      isInit: isInit ?? this.isInit,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInit': isInit,
      'row': row,
      'col': col,
    };
  }

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      isInit: map['isInit'] as bool,
      row: map['row'] as int,
      col: map['col'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coordinates.fromJson(String source) =>
      Coordinates.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Coordinates(isInit: $isInit, row: $row, col: $col)';

  @override
  bool operator ==(covariant Coordinates other) {
    if (identical(this, other)) return true;

    return other.isInit == isInit && other.row == row && other.col == col;
  }

  @override
  int get hashCode => isInit.hashCode ^ row.hashCode ^ col.hashCode;
}
