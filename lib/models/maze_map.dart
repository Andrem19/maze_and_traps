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
  Coordinates Player_A_Coord;
  Coordinates Player_B_Coord;
  MazeMap({
    required this.mazeMap,
    required this.Player_A_Coord,
    required this.Player_B_Coord,
  });

  void reverse() {
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

  String calcDistToFinish(String role) {
    int numRows = mazeMap.length;
    int numCols = mazeMap[0].length;

    int playerAFinishRow = 0;
    int playerAFinishCol = mazeMap[0].length - 1;

    int playerBFinishRow = role == 'A'? mazeMap.length - 1 : 0;
    int playerBFinishCol = role == 'A'? 0 : mazeMap[0].length - 1;

    int playerARow = Player_A_Coord.row;
    int playerACol = Player_A_Coord.col;

    int playerBRow = Player_B_Coord.row;
    int playerBCol = Player_B_Coord.col;

    double distanceToFinishA = sqrt(pow(playerAFinishRow - playerARow, 2) +
        pow(playerAFinishCol - playerACol, 2));
    double distanceToFinishB = sqrt(pow(playerBFinishRow - playerBRow, 2) +
        pow(playerBFinishCol - playerBCol, 2));
    if (distanceToFinishA < distanceToFinishB) {
      return "A";
    } else {
      return "B";
    }
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mazeMap': mazeMap.asMap().map((key, value) {
        return MapEntry(
            key.toString(),
            value.asMap().map((k, v) {
              return MapEntry(k.toString(), v.toMap());
            }));
      }),
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
