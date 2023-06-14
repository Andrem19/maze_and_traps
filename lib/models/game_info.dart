// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:convert';

import 'gameInfoCloud.dart';
import 'maze_map.dart';
import 'maze_map.dart';

class GameInfo {
  String scrolOwner;
  Coordinates Teleport_A;
  Coordinates Teleport_B;
  Coordinates Frozen_trap_A;
  Coordinates Frozen_trap_B;
  GameInfo({
    required this.scrolOwner,
    required this.Teleport_A,
    required this.Teleport_B,
    required this.Frozen_trap_A,
    required this.Frozen_trap_B,
  });

  static GameInfo createEmptyGameInfo(MazeMap map) {
    return GameInfo(
      scrolOwner: 'none',
      Frozen_trap_A: Coordinates(isInit: false, row: 0, col: 0),
      Frozen_trap_B: Coordinates(isInit: false, row: 0, col: 0),
      Teleport_A: Coordinates(isInit: false, row: 0, col: 0),
      Teleport_B: Coordinates(isInit: false, row: 0, col: 0),
    );
  }

  static GameInfo reverseGameInfo(GameInfo info, MazeMap map) {
    if (info.Frozen_trap_A.isInit) {
      info.Frozen_trap_A = Coordinates(
          isInit: info.Frozen_trap_A.isInit,
          row: (map.mazeMap.length - 1) - info.Frozen_trap_A.row,
          col: (map.mazeMap[0].length - 1) - info.Frozen_trap_A.col);
    }
    // if (info.Frozen_trap_B.isInit) {
    //   info.Frozen_trap_B = Coordinates(
    //       isInit: info.Frozen_trap_B.isInit,
    //       row: (map.mazeMap.length - 1) - info.Frozen_trap_B.row,
    //       col: (map.mazeMap[0].length - 1) - info.Frozen_trap_B.col);
    // }

    if (info.Teleport_A.isInit) {
      info.Teleport_A = Coordinates(
          isInit: info.Teleport_A.isInit,
          row: (map.mazeMap.length - 1) - info.Teleport_A.row,
          col: (map.mazeMap[0].length - 1) - info.Teleport_A.col);
    }

    // if (info.Teleport_B.isInit) {
    //   info.Teleport_B = Coordinates(
    //       isInit: info.Teleport_B.isInit,
    //       row: (map.mazeMap.length - 1) - info.Teleport_B.row,
    //       col: (map.mazeMap[0].length - 1) - info.Teleport_B.col);
    // }
    return info;
  }

  GameInfoCloud GameInfoToCloud(String myRole) {
    if (myRole == 'A') {
      return GameInfoCloud(frozen: Frozen_trap_A, teleport: Teleport_A);
    } else {
      return GameInfoCloud(frozen: Frozen_trap_B, teleport: Teleport_B);
    }
  }

  GameInfo copyWith({
    String? scrolOwner,
    Coordinates? Teleport_A,
    Coordinates? Teleport_B,
    Coordinates? Frozen_trap_A,
    Coordinates? Frozen_trap_B,
  }) {
    return GameInfo(
      scrolOwner: scrolOwner ?? this.scrolOwner,
      Teleport_A: Teleport_A ?? this.Teleport_A,
      Teleport_B: Teleport_B ?? this.Teleport_B,
      Frozen_trap_A: Frozen_trap_A ?? this.Frozen_trap_A,
      Frozen_trap_B: Frozen_trap_B ?? this.Frozen_trap_B,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scrolOwner': scrolOwner,
      'Teleport_A': Teleport_A.toMap(),
      'Teleport_B': Teleport_B.toMap(),
      'Frozen_trap_A': Frozen_trap_A.toMap(),
      'Frozen_trap_B': Frozen_trap_B.toMap(),
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    return GameInfo(
      scrolOwner: map['scrolOwner'] as String,
      Teleport_A: Coordinates.fromMap(map['Teleport_A'] as Map<String,dynamic>),
      Teleport_B: Coordinates.fromMap(map['Teleport_B'] as Map<String,dynamic>),
      Frozen_trap_A: Coordinates.fromMap(map['Frozen_trap_A'] as Map<String,dynamic>),
      Frozen_trap_B: Coordinates.fromMap(map['Frozen_trap_B'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfo(scrolOwner: $scrolOwner, Teleport_A: $Teleport_A, Teleport_B: $Teleport_B, Frozen_trap_A: $Frozen_trap_A, Frozen_trap_B: $Frozen_trap_B)';
  }

  @override
  bool operator ==(covariant GameInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.scrolOwner == scrolOwner &&
      other.Teleport_A == Teleport_A &&
      other.Teleport_B == Teleport_B &&
      other.Frozen_trap_A == Frozen_trap_A &&
      other.Frozen_trap_B == Frozen_trap_B;
  }

  @override
  int get hashCode {
    return scrolOwner.hashCode ^
      Teleport_A.hashCode ^
      Teleport_B.hashCode ^
      Frozen_trap_A.hashCode ^
      Frozen_trap_B.hashCode;
  }
}
