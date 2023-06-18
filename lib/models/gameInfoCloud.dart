// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mazeandtraps/models/maze_map.dart';

import 'game_info.dart';

class GameInfoCloud {
  Coordinates frozen;
  Coordinates teleport;
  Coordinates bomb;
  Coordinates knifes;
  Coordinates speed_1;
  Coordinates speed_2;
  Coordinates through_wall;
  Coordinates blindness;
  Coordinates poison;
  Coordinates healing;
  Coordinates meteor;
  Coordinates meteorRain;
  Coordinates invisibility;
  Coordinates builder;
  GameInfoCloud({
    required this.frozen,
    required this.teleport,
    required this.bomb,
    required this.knifes,
    required this.speed_1,
    required this.speed_2,
    required this.through_wall,
    required this.blindness,
    required this.poison,
    required this.healing,
    required this.meteor,
    required this.meteorRain,
    required this.invisibility,
    required this.builder,
  });

  GameInfoCloud copyWith({
    Coordinates? frozen,
    Coordinates? teleport,
    Coordinates? bomb,
    Coordinates? knifes,
    Coordinates? speed_1,
    Coordinates? speed_2,
    Coordinates? through_wall,
    Coordinates? blindness,
    Coordinates? poison,
    Coordinates? healing,
    Coordinates? meteor,
    Coordinates? meteorRain,
    Coordinates? invisibility,
    Coordinates? builder,
  }) {
    return GameInfoCloud(
      frozen: frozen ?? this.frozen,
      teleport: teleport ?? this.teleport,
      bomb: bomb ?? this.bomb,
      knifes: knifes ?? this.knifes,
      speed_1: speed_1 ?? this.speed_1,
      speed_2: speed_2 ?? this.speed_2,
      through_wall: through_wall ?? this.through_wall,
      blindness: blindness ?? this.blindness,
      poison: poison ?? this.poison,
      healing: healing ?? this.healing,
      meteor: meteor ?? this.meteor,
      meteorRain: meteorRain ?? this.meteorRain,
      invisibility: invisibility ?? this.invisibility,
      builder: builder ?? this.builder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frozen': frozen.toMap(),
      'teleport': teleport.toMap(),
      'bomb': bomb.toMap(),
      'knifes': knifes.toMap(),
      'speed_1': speed_1.toMap(),
      'speed_2': speed_2.toMap(),
      'through_wall': through_wall.toMap(),
      'blindness': blindness.toMap(),
      'poison': poison.toMap(),
      'healing': healing.toMap(),
      'meteor': meteor.toMap(),
      'meteorRain': meteorRain.toMap(),
      'invisibility': invisibility.toMap(),
      'builder': builder.toMap(),
    };
  }

  static GameInfoCloud createEmptyForServer() {
    return GameInfoCloud(
      frozen: Coordinates(isInit: false, row: 0, col: 0),
      teleport: Coordinates(isInit: false, row: 0, col: 0),
      bomb: Coordinates(isInit: false, row: 0, col: 0),
      knifes: Coordinates(isInit: false, row: 0, col: 0),
      speed_1: Coordinates(isInit: false, row: 0, col: 0),
      speed_2: Coordinates(isInit: false, row: 0, col: 0),
      through_wall: Coordinates(isInit: false, row: 0, col: 0),
      blindness: Coordinates(isInit: false, row: 0, col: 0),
      poison: Coordinates(isInit: false, row: 0, col: 0),
      healing: Coordinates(isInit: false, row: 0, col: 0),
      meteor: Coordinates(isInit: false, row: 0, col: 0),
      meteorRain: Coordinates(isInit: false, row: 0, col: 0),
      invisibility: Coordinates(isInit: false, row: 0, col: 0),
      builder: Coordinates(isInit: false, row: 0, col: 0),
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
          Speed_increase_1_5_A: oldGI.Speed_increase_1_5_A,
          Speed_increase_1_5_B: speed_1,
          Speed_increase_2_A: oldGI.Speed_increase_1_5_A,
          Speed_increase_2_B: speed_2,
          Go_through_the_wall_A: oldGI.Go_through_the_wall_A,
          Go_through_the_wall_B: through_wall,
          Blindness_A: oldGI.Blindness_A,
          Blindness_B: blindness,
          Poison_A: oldGI.Poison_A,
          Poison_B: poison,
          Healing_A: oldGI.Healing_A,
          Healing_B: healing,
          Meteor_A: oldGI.Meteor_A,
          Meteor_B: meteor,
          MeteorRain_A: oldGI.MeteorRain_A,
          MeteorRain_B: meteorRain,
          Invisibility_A: oldGI.Invisibility_A,
          Invisibility_B: invisibility,
          Builder_A: oldGI.Blindness_A,
          Builder_B: builder,
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
          Knifes_B: oldGI.Knifes_B,
          Speed_increase_1_5_A: speed_1,
          Speed_increase_1_5_B: oldGI.Speed_increase_1_5_B,
          Speed_increase_2_A: speed_2,
          Speed_increase_2_B: oldGI.Speed_increase_1_5_B,
          Go_through_the_wall_A: through_wall,
          Go_through_the_wall_B: oldGI.Go_through_the_wall_B,
          Blindness_A: blindness,
          Blindness_B: oldGI.Blindness_B,
          Poison_A: poison,
          Poison_B: oldGI.Poison_B,
          Healing_A: healing,
          Healing_B: oldGI.Healing_B,
          Meteor_A: meteor,
          Meteor_B: oldGI.Meteor_B,
          MeteorRain_A: meteorRain,
          MeteorRain_B: oldGI.MeteorRain_B,
          Invisibility_A: invisibility,
          Invisibility_B: oldGI.Invisibility_B,
          Builder_A: builder,
          Builder_B: oldGI.Blindness_B,
          );
    }
  }

  factory GameInfoCloud.fromMap(Map<String, dynamic> map) {
    return GameInfoCloud(
      frozen: Coordinates.fromMap(map['frozen'] as Map<String,dynamic>),
      teleport: Coordinates.fromMap(map['teleport'] as Map<String,dynamic>),
      bomb: Coordinates.fromMap(map['bomb'] as Map<String,dynamic>),
      knifes: Coordinates.fromMap(map['knifes'] as Map<String,dynamic>),
      speed_1: Coordinates.fromMap(map['speed_1'] as Map<String,dynamic>),
      speed_2: Coordinates.fromMap(map['speed_2'] as Map<String,dynamic>),
      through_wall: Coordinates.fromMap(map['through_wall'] as Map<String,dynamic>),
      blindness: Coordinates.fromMap(map['blindness'] as Map<String,dynamic>),
      poison: Coordinates.fromMap(map['poison'] as Map<String,dynamic>),
      healing: Coordinates.fromMap(map['healing'] as Map<String,dynamic>),
      meteor: Coordinates.fromMap(map['meteor'] as Map<String,dynamic>),
      meteorRain: Coordinates.fromMap(map['meteorRain'] as Map<String,dynamic>),
      invisibility: Coordinates.fromMap(map['invisibility'] as Map<String,dynamic>),
      builder: Coordinates.fromMap(map['builder'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfoCloud.fromJson(String source) =>
      GameInfoCloud.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfoCloud(frozen: $frozen, teleport: $teleport, bomb: $bomb, knifes: $knifes, speed_1: $speed_1, speed_2: $speed_2, through_wall: $through_wall, blindness: $blindness, poison: $poison, healing: $healing, meteor: $meteor, meteorRain: $meteorRain, invisibility: $invisibility, builder: $builder)';
  }

  @override
  bool operator ==(covariant GameInfoCloud other) {
    if (identical(this, other)) return true;
  
    return 
      other.frozen == frozen &&
      other.teleport == teleport &&
      other.bomb == bomb &&
      other.knifes == knifes &&
      other.speed_1 == speed_1 &&
      other.speed_2 == speed_2 &&
      other.through_wall == through_wall &&
      other.blindness == blindness &&
      other.poison == poison &&
      other.healing == healing &&
      other.meteor == meteor &&
      other.meteorRain == meteorRain &&
      other.invisibility == invisibility &&
      other.builder == builder;
  }

  @override
  int get hashCode {
    return frozen.hashCode ^
      teleport.hashCode ^
      bomb.hashCode ^
      knifes.hashCode ^
      speed_1.hashCode ^
      speed_2.hashCode ^
      through_wall.hashCode ^
      blindness.hashCode ^
      poison.hashCode ^
      healing.hashCode ^
      meteor.hashCode ^
      meteorRain.hashCode ^
      invisibility.hashCode ^
      builder.hashCode;
  }
}
