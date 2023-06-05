// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'maze_map.dart';

class GameInfo {
  String myRole;
  Coordinates DoorTeleport_A;
  Coordinates DoorTeleport_B;
  Coordinates Frozen_trap_A;
  Coordinates Frozen_trap_B;
  Coordinates ExitTeleport_A;
  Coordinates ExitTeleport_B;
  int Player_A_Frozen;
  int Player_B_Frozen;
  GameInfo({
    required this.myRole,
    required this.DoorTeleport_A,
    required this.DoorTeleport_B,
    required this.Frozen_trap_A,
    required this.Frozen_trap_B,
    required this.ExitTeleport_A,
    required this.ExitTeleport_B,
    required this.Player_A_Frozen,
    required this.Player_B_Frozen,
  });

  static GameInfo createEmptyGameInfo(MazeMap map) {
    return GameInfo(
        myRole: '',
        DoorTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        DoorTeleport_B: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_A: Coordinates(isInit: false, row: 0, col: 0),
        Frozen_trap_B: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_A: Coordinates(isInit: false, row: 0, col: 0),
        ExitTeleport_B: Coordinates(isInit: false, row: 0, col: 0),
        Player_A_Frozen: 0,
        Player_B_Frozen: 0);
  }

  static GameInfo reverseGameInfo(GameInfo info, MazeMap map) {
    if (info.Frozen_trap_A.isInit) {
      info.Frozen_trap_A = Coordinates(
          isInit: info.Frozen_trap_A.isInit,
          row: (map.mazeMap.length - 1) - info.Frozen_trap_A.row,
          col: (map.mazeMap[0].length - 1) - info.Frozen_trap_A.col);
    }
    if (info.Frozen_trap_B.isInit) {
      info.Frozen_trap_B = Coordinates(
          isInit: info.Frozen_trap_B.isInit,
          row: (map.mazeMap.length - 1) - info.Frozen_trap_B.row,
          col: (map.mazeMap[0].length - 1) - info.Frozen_trap_B.col);
    }

    if (info.DoorTeleport_A.isInit) {
      info.DoorTeleport_A = Coordinates(
          isInit: info.DoorTeleport_A.isInit,
          row: (map.mazeMap.length - 1) - info.DoorTeleport_A.row,
          col: (map.mazeMap[0].length - 1) - info.DoorTeleport_A.col);
    }

    if (info.DoorTeleport_B.isInit) {
      info.DoorTeleport_B = Coordinates(
          isInit: info.DoorTeleport_B.isInit,
          row: (map.mazeMap.length - 1) - info.DoorTeleport_B.row,
          col: (map.mazeMap[0].length - 1) - info.DoorTeleport_B.col);
    }

    if (info.ExitTeleport_A.isInit) {
      info.ExitTeleport_A = Coordinates(
          isInit: info.ExitTeleport_A.isInit,
          row: (map.mazeMap.length - 1) - info.ExitTeleport_A.row,
          col: (map.mazeMap[0].length - 1) - info.ExitTeleport_A.col);
    }

    if (info.ExitTeleport_B.isInit) {
      info.ExitTeleport_B = Coordinates(
          isInit: info.ExitTeleport_B.isInit,
          row: (map.mazeMap.length - 1) - info.ExitTeleport_B.row,
          col: (map.mazeMap[0].length - 1) - info.ExitTeleport_B.col);
    }
    return info;
  }

  GameInfo copyWith({
    String? myRole,
    Coordinates? DoorTeleport_A,
    Coordinates? DoorTeleport_B,
    Coordinates? Frozen_trap_A,
    Coordinates? Frozen_trap_B,
    Coordinates? ExitTeleport_A,
    Coordinates? ExitTeleport_B,
    int? Player_A_Frozen,
    int? Player_B_Frozen,
  }) {
    return GameInfo(
      myRole: myRole ?? this.myRole,
      DoorTeleport_A: DoorTeleport_A ?? this.DoorTeleport_A,
      DoorTeleport_B: DoorTeleport_B ?? this.DoorTeleport_B,
      Frozen_trap_A: Frozen_trap_A ?? this.Frozen_trap_A,
      Frozen_trap_B: Frozen_trap_B ?? this.Frozen_trap_B,
      ExitTeleport_A: ExitTeleport_A ?? this.ExitTeleport_A,
      ExitTeleport_B: ExitTeleport_B ?? this.ExitTeleport_B,
      Player_A_Frozen: Player_A_Frozen ?? this.Player_A_Frozen,
      Player_B_Frozen: Player_B_Frozen ?? this.Player_B_Frozen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'myRole': myRole,
      'DoorTeleport_A': DoorTeleport_A.toMap(),
      'DoorTeleport_B': DoorTeleport_B.toMap(),
      'Frozen_trap_A': Frozen_trap_A.toMap(),
      'Frozen_trap_B': Frozen_trap_B.toMap(),
      'ExitTeleport_A': ExitTeleport_A.toMap(),
      'ExitTeleport_B': ExitTeleport_B.toMap(),
      'Player_A_Frozen': Player_A_Frozen,
      'Player_B_Frozen': Player_B_Frozen,
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    return GameInfo(
      myRole: map['myRole'] as String,
      DoorTeleport_A: Coordinates.fromMap(map['DoorTeleport_A'] as Map<String,dynamic>),
      DoorTeleport_B: Coordinates.fromMap(map['DoorTeleport_B'] as Map<String,dynamic>),
      Frozen_trap_A: Coordinates.fromMap(map['Frozen_trap_A'] as Map<String,dynamic>),
      Frozen_trap_B: Coordinates.fromMap(map['Frozen_trap_B'] as Map<String,dynamic>),
      ExitTeleport_A: Coordinates.fromMap(map['ExitTeleport_A'] as Map<String,dynamic>),
      ExitTeleport_B: Coordinates.fromMap(map['ExitTeleport_B'] as Map<String,dynamic>),
      Player_A_Frozen: map['Player_A_Frozen'] as int,
      Player_B_Frozen: map['Player_B_Frozen'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfo(myRole: $myRole, DoorTeleport_A: $DoorTeleport_A, DoorTeleport_B: $DoorTeleport_B, Frozen_trap_A: $Frozen_trap_A, Frozen_trap_B: $Frozen_trap_B, ExitTeleport_A: $ExitTeleport_A, ExitTeleport_B: $ExitTeleport_B, Player_A_Frozen: $Player_A_Frozen, Player_B_Frozen: $Player_B_Frozen)';
  }

  @override
  bool operator ==(covariant GameInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.myRole == myRole &&
      other.DoorTeleport_A == DoorTeleport_A &&
      other.DoorTeleport_B == DoorTeleport_B &&
      other.Frozen_trap_A == Frozen_trap_A &&
      other.Frozen_trap_B == Frozen_trap_B &&
      other.ExitTeleport_A == ExitTeleport_A &&
      other.ExitTeleport_B == ExitTeleport_B &&
      other.Player_A_Frozen == Player_A_Frozen &&
      other.Player_B_Frozen == Player_B_Frozen;
  }

  @override
  int get hashCode {
    return myRole.hashCode ^
      DoorTeleport_A.hashCode ^
      DoorTeleport_B.hashCode ^
      Frozen_trap_A.hashCode ^
      Frozen_trap_B.hashCode ^
      ExitTeleport_A.hashCode ^
      ExitTeleport_B.hashCode ^
      Player_A_Frozen.hashCode ^
      Player_B_Frozen.hashCode;
  }
}
