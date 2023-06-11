// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mazeandtraps/models/maze_map.dart';

import 'game_info.dart';

class GameInfoCloud {
  Coordinates frozen;
  Coordinates teleport;
  GameInfoCloud({
    required this.frozen,
    required this.teleport,
  });

  GameInfoCloud copyWith({
    Coordinates? frozen,
    Coordinates? teleport,
  }) {
    return GameInfoCloud(
      frozen: frozen ?? this.frozen,
      teleport: teleport ?? this.teleport,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frozen': frozen.toMap(),
      'teleport': teleport.toMap(),
    };
  }

  static GameInfoCloud createEmptyForServer() {
    return GameInfoCloud(
      frozen: Coordinates(isInit: false, row: 0, col: 0),
      teleport: Coordinates(isInit: false, row: 0, col: 0),
    );
  }

  GameInfo CloudToGameInfo(String role, GameInfo oldGI, String scrollOwner) {
    if (role == 'A') {
      return GameInfo(
          scrolOwner: scrollOwner,
          Teleport_A: oldGI.Teleport_A,
          Teleport_B: teleport,
          Frozen_trap_A: oldGI.Frozen_trap_A,
          Frozen_trap_B: frozen);
    } else {
      return GameInfo(
          scrolOwner: scrollOwner,
          Teleport_A: teleport,
          Teleport_B: oldGI.Teleport_B,
          Frozen_trap_A: frozen,
          Frozen_trap_B: oldGI.Frozen_trap_B);
    }
  }

  factory GameInfoCloud.fromMap(Map<String, dynamic> map) {
    return GameInfoCloud(
      frozen: Coordinates.fromMap(map['frozen'] as Map<String, dynamic>),
      teleport: Coordinates.fromMap(map['teleport'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfoCloud.fromJson(String source) =>
      GameInfoCloud.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GameInfoCloud(frozen: $frozen, teleport: $teleport)';

  @override
  bool operator ==(covariant GameInfoCloud other) {
    if (identical(this, other)) return true;

    return other.frozen == frozen && other.teleport == teleport;
  }

  @override
  int get hashCode => frozen.hashCode ^ teleport.hashCode;
}
