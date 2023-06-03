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
  Coordinates DoorTeleport_A;
  Coordinates DoorTeleport_B;
  Coordinates Frozen_trap_A;
  Coordinates Frozen_trap_B;
  bool A_FrozenInstalled;
  bool B_FrozenInstalled;
  bool A_DoorInstalled;
  bool B_DoorInstalled;
  bool A_ExitInstalled;
  bool B_ExitInstalled;
  int Player_A_Frozen;
  int Player_B_Frozen;
  Coordinates ExitTeleport_A;
  Coordinates ExitTeleport_B;
  MazeMap({
    required this.mazeMap,
    required this.message_A,
    required this.message_B,
    required this.Player_A_Coord,
    required this.Player_B_Coord,
    required this.Frozen_trap_A,
    required this.Frozen_trap_B,
    required this.DoorTeleport_A,
    required this.DoorTeleport_B,
    required this.A_FrozenInstalled,
    required this.B_FrozenInstalled,
    required this.A_DoorInstalled,
    required this.B_DoorInstalled,
    required this.A_ExitInstalled,
    required this.B_ExitInstalled,
    required this.Player_A_Frozen,
    required this.Player_B_Frozen,
    required this.ExitTeleport_A,
    required this.ExitTeleport_B,
  });

  void reverse() {
    String tempMessage = message_A;
    message_A = message_B;
    message_B = tempMessage;

    Coordinates tempCoords = Player_A_Coord;
    Player_A_Coord = Player_B_Coord;
    Player_B_Coord = tempCoords;

    bool tempFrozen = A_FrozenInstalled;
    A_FrozenInstalled = B_FrozenInstalled;
    B_FrozenInstalled = tempFrozen;

    bool tempDoor = A_DoorInstalled;
    A_DoorInstalled = B_DoorInstalled;
    B_DoorInstalled = tempDoor;

    bool tempExit = A_ExitInstalled;
    A_ExitInstalled = B_ExitInstalled;
    B_ExitInstalled = tempExit;

    int tempFrozenCount = Player_A_Frozen;
    Player_A_Frozen = Player_B_Frozen;
    Player_B_Frozen = tempFrozenCount;

    Coordinates tempExitTeleport = ExitTeleport_A;
    ExitTeleport_A = ExitTeleport_B;
    ExitTeleport_B = tempExitTeleport;
    mazeMap = mazeMap.reversed.toList();
    for (var i = 0; i < mazeMap.length; i++) {
      mazeMap[i] = mazeMap[i].reversed.toList();
      for (var j = 0; j < mazeMap[i].length; j++) {}
    }
  }

  void reversePlus() {
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
  }

  GameInfo getGameInfo() {
    return GameInfo(
        DoorTeleport_A: DoorTeleport_A,
        DoorTeleport_B: DoorTeleport_B,
        Frozen_trap_A: Frozen_trap_A,
        Frozen_trap_B: Frozen_trap_B,
        ExitTeleport_A: ExitTeleport_A,
        ExitTeleport_B: ExitTeleport_B);
  }

  void fromGameInfo(GameInfo info) {
    DoorTeleport_A = info.DoorTeleport_A;
    DoorTeleport_B = info.DoorTeleport_B;
    Frozen_trap_A = info.Frozen_trap_A;
    Frozen_trap_B = info.Frozen_trap_B;
    ExitTeleport_A = info.ExitTeleport_A;
    ExitTeleport_B = info.ExitTeleport_B;
  }
  double calculateDistance() {
  int numRows = mazeMap.length;
  int numCols = mazeMap[0].length;

  int player1Row = Player_A_Coord.row;
  int player1Col = Player_A_Coord.col;
  int player2Row = Player_B_Coord.row;
  int player2Col = Player_B_Coord.col;

  double distance = sqrt(pow(player2Row - player1Row, 2) + pow(player2Col - player1Col, 2));

  return distance;
}


  void countRadiusAroundPlayer_A(int shaddowRadius, bool withBorder) {
  mazeMap.forEach((row) => row.forEach((node) => node.isShaddow = true));
  int startRow = Player_A_Coord.row - shaddowRadius - 1 < 0 ? 0 : Player_A_Coord.row - shaddowRadius - 1;
  int endRow = Player_A_Coord.row + shaddowRadius + 1 >= mazeMap.length ? mazeMap.length - 1 : Player_A_Coord.row + shaddowRadius + 1;
  int startCol = Player_A_Coord.col - shaddowRadius - 1 < 0 ? 0 : Player_A_Coord.col - shaddowRadius - 1;
  int endCol = Player_A_Coord.col + shaddowRadius + 1 >= mazeMap[0].length ? mazeMap[0].length - 1 : Player_A_Coord.col + shaddowRadius + 1;
  for (int row = startRow; row <= endRow; row++) {
    for (int col = startCol; col <= endCol; col++) {
      double distance = sqrt(pow(Player_A_Coord.row - row, 2) + pow(Player_A_Coord.col - col, 2));
      if (distance <= shaddowRadius) {
        mazeMap[row][col].isShaddow = false;
      } else if (withBorder && distance > shaddowRadius && distance <= shaddowRadius + 1) {
        mazeMap[row][col].halfShaddow = true;
      }
    }
  }
}

void countRadiusAroundPlayer_B(int shaddowRadius, bool withBorder) {
  mazeMap.forEach((row) => row.forEach((node) => node.isShaddow = true));
  int startRow = Player_B_Coord.row - shaddowRadius - 1 < 0 ? 0 : Player_B_Coord.row - shaddowRadius - 1;
  int endRow = Player_B_Coord.row + shaddowRadius + 1 >= mazeMap.length ? mazeMap.length - 1 : Player_B_Coord.row + shaddowRadius + 1;
  int startCol = Player_B_Coord.col - shaddowRadius - 1 < 0 ? 0 : Player_B_Coord.col - shaddowRadius - 1;
  int endCol = Player_B_Coord.col + shaddowRadius + 1 >= mazeMap[0].length ? mazeMap[0].length - 1 : Player_B_Coord.col + shaddowRadius + 1;
  for (int row = startRow; row <= endRow; row++) {
    for (int col = startCol; col <= endCol; col++) {
      double distance = sqrt(pow(Player_B_Coord.row - row, 2) + pow(Player_B_Coord.col - col, 2));
      if (distance <= shaddowRadius) {
        mazeMap[row][col].isShaddow = false;
      } else if (withBorder && distance > shaddowRadius && distance <= shaddowRadius + 1) {
        mazeMap[row][col].halfShaddow = true;
      }
    }
  }
}


  bool MovePlayer_A(Direction direction) {
    if (Player_A_Frozen != 0) {
      Player_A_Frozen -= 1;
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

    if (Frozen_trap_B.row == Player_A_Coord.row &&
        Frozen_trap_B.col == Player_A_Coord.col) {
      Player_A_Frozen = 8;
      FlameAudio.play('freeze.wav');
      message_B = 'Player was frozen';
    }

    if (DoorTeleport_B.row == Player_A_Coord.row &&
        DoorTeleport_B.col == Player_A_Coord.col &&
        ExitTeleport_B.isInit) {
      Player_A_Coord.row = ExitTeleport_B.row;
      Player_A_Coord.col = ExitTeleport_B.col;
      message_A = 'Teleport trap';
      FlameAudio.play('teleport.mp3');
      ExitTeleport_B.isInit = false;
      return true;
    }
    return false;
  }

  bool MovePlayer_B(Direction direction) {
    if (Player_B_Frozen != 0) {
      Player_B_Frozen -= 1;
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
    if (Frozen_trap_A.row == Player_B_Coord.row &&
        Frozen_trap_A.col == Player_B_Coord.col) {
      Player_B_Frozen = 8;
      FlameAudio.play('freeze.wav');
      message_B = 'Player was frozen';
    }

    if (DoorTeleport_A.row == Player_B_Coord.row &&
        DoorTeleport_A.col == Player_B_Coord.col &&
        ExitTeleport_A.isInit) {
      Player_B_Coord.row = ExitTeleport_A.row;
      Player_B_Coord.col = ExitTeleport_A.col;
      message_B = 'Teleport trap';
      FlameAudio.play('teleport.mp3');
      ExitTeleport_A.isInit = false;
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

  void instalFrozen_A() {
    if (!A_FrozenInstalled) {
      Frozen_trap_A = Coordinates(
          isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
      A_FrozenInstalled = true;
      message_A = 'Frozen trap instaled';
      FlameAudio.play('freeze.wav');
    }
  }

  void instalDoor_A() {
    if (!A_DoorInstalled) {
      DoorTeleport_A = Coordinates(
          isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
      A_DoorInstalled = true;
      message_A = 'Door trap instaled';
    }
  }

  void instalExit_A() {
    if (!A_ExitInstalled && A_DoorInstalled) {
      A_ExitInstalled = true;
      ExitTeleport_A = Coordinates(
          isInit: true, row: Player_A_Coord.row, col: Player_A_Coord.col);
      message_A = 'Exit trap instaled';
    } else {
      message_A = 'first you should to install the door';
    }
  }

  void instalFrozen_B() {
    if (!B_FrozenInstalled) {
      Frozen_trap_B = Coordinates(
          isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
      B_FrozenInstalled = true;
      message_B = 'Frozen trap instaled';
      FlameAudio.play('freeze.wav');
    }
  }

  void instalDoor_B() {
    if (!B_DoorInstalled) {
      DoorTeleport_B = Coordinates(
          isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
      B_DoorInstalled = true;
      message_B = 'Door trap instaled';
    }
  }

  void instalExit_B() {
    if (!B_ExitInstalled && B_DoorInstalled) {
      B_ExitInstalled = true;
      ExitTeleport_B = Coordinates(
          isInit: true, row: Player_B_Coord.row, col: Player_B_Coord.col);
      message_B = 'Exit trap instaled';
    } else {
      message_B = 'first you should to install the door';
    }
  }

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
      'Frozen_trap_A': Frozen_trap_A.toMap(),
      'Frozen_trap_B': Frozen_trap_B.toMap(),
      'DoorTeleport_A': DoorTeleport_A.toMap(),
      'DoorTeleport_B': DoorTeleport_B.toMap(),
      'A_FrozenInstalled': A_FrozenInstalled,
      'B_FrozenInstalled': B_FrozenInstalled,
      'A_DoorInstalled': A_DoorInstalled,
      'B_DoorInstalled': B_DoorInstalled,
      'A_ExitInstalled': A_ExitInstalled,
      'B_ExitInstalled': B_ExitInstalled,
      'Player_A_Frozen': Player_A_Frozen,
      'Player_B_Frozen': Player_B_Frozen,
      'ExitTeleport_A': ExitTeleport_A.toMap(),
      'ExitTeleport_B': ExitTeleport_B.toMap(),
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
      Frozen_trap_A:
          Coordinates.fromMap(map['Frozen_trap_A'] as Map<String, dynamic>),
      Frozen_trap_B:
          Coordinates.fromMap(map['Frozen_trap_B'] as Map<String, dynamic>),
      DoorTeleport_A:
          Coordinates.fromMap(map['DoorTeleport_A'] as Map<String, dynamic>),
      DoorTeleport_B:
          Coordinates.fromMap(map['DoorTeleport_B'] as Map<String, dynamic>),
      A_FrozenInstalled: map['A_FrozenInstalled'] as bool,
      B_FrozenInstalled: map['B_FrozenInstalled'] as bool,
      A_DoorInstalled: map['A_DoorInstalled'] as bool,
      B_DoorInstalled: map['B_DoorInstalled'] as bool,
      A_ExitInstalled: map['A_ExitInstalled'] as bool,
      B_ExitInstalled: map['B_ExitInstalled'] as bool,
      Player_A_Frozen: map['Player_A_Frozen'] as int,
      Player_B_Frozen: map['Player_B_Frozen'] as int,
      ExitTeleport_A:
          Coordinates.fromMap(map['ExitTeleport_A'] as Map<String, dynamic>),
      ExitTeleport_B:
          Coordinates.fromMap(map['ExitTeleport_B'] as Map<String, dynamic>),
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
