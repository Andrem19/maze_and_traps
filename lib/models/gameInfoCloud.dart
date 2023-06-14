// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mazeandtraps/models/maze_map.dart';

import 'game_info.dart';

class GameInfoCloud {
  Coordinates frozen;
  Coordinates teleport;
  Coordinates bomb;
  Coordinates knifes;
  GameInfoCloud({
    required this.frozen,
    required this.teleport,
    required this.bomb,
    required this.knifes,
  });

  GameInfoCloud copyWith({
    Coordinates? frozen,
    Coordinates? teleport,
    Coordinates? bomb,
    Coordinates? knifes,
  }) {
    return GameInfoCloud(
      frozen: frozen ?? this.frozen,
      teleport: teleport ?? this.teleport,
      bomb: bomb ?? this.bomb,
      knifes: knifes ?? this.knifes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frozen': frozen.toMap(),
      'teleport': teleport.toMap(),
      'bomb': bomb.toMap(),
      'knifes': knifes.toMap(),
    };
  }

  static GameInfoCloud createEmptyForServer() {
    return GameInfoCloud(
      frozen: Coordinates(isInit: false, row: 0, col: 0),
      teleport: Coordinates(isInit: false, row: 0, col: 0),
      bomb: Coordinates(isInit: false, row: 0, col: 0),
      knifes: Coordinates(isInit: false, row: 0, col: 0),
    );
  }

  GameInfo CloudToGameInfo(String role, GameInfo oldGI, String scrollOwner) {
    if (role == 'A') {
      return GameInfo(
          scrolOwner: scrollOwner,
          Teleport_A: oldGI.Teleport_A,
          Teleport_B: teleport,
          Frozen_trap_A: oldGI.Frozen_trap_A,
          Frozen_trap_B: frozen,
          Bomb_A: oldGI.Bomb_A,
          Bomb_B: bomb,
          Knifes_A: oldGI.Knifes_A,
          Knifes_B: knifes,
          );
    } else {
      return GameInfo(
          scrolOwner: scrollOwner,
          Teleport_A: teleport,
          Teleport_B: oldGI.Teleport_B,
          Frozen_trap_A: frozen,
          Frozen_trap_B: oldGI.Frozen_trap_B,
          Bomb_A: bomb,
          Bomb_B: oldGI.Bomb_B,
          Knifes_A: knifes,
          Knifes_B: oldGI.Knifes_B
          );
    }
  }

  factory GameInfoCloud.fromMap(Map<String, dynamic> map) {
    return GameInfoCloud(
      frozen: Coordinates.fromMap(map['frozen'] as Map<String,dynamic>),
      teleport: Coordinates.fromMap(map['teleport'] as Map<String,dynamic>),
      bomb: Coordinates.fromMap(map['bomb'] as Map<String,dynamic>),
      knifes: Coordinates.fromMap(map['knifes'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfoCloud.fromJson(String source) =>
      GameInfoCloud.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfoCloud(frozen: $frozen, teleport: $teleport, bomb: $bomb, knifes: $knifes)';
  }

  @override
  bool operator ==(covariant GameInfoCloud other) {
    if (identical(this, other)) return true;
  
    return 
      other.frozen == frozen &&
      other.teleport == teleport &&
      other.bomb == bomb &&
      other.knifes == knifes;
  }

  @override
  int get hashCode {
    return frozen.hashCode ^
      teleport.hashCode ^
      bomb.hashCode ^
      knifes.hashCode;
  }
}
