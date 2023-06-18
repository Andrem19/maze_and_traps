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
  Coordinates Bomb_A;
  Coordinates Bomb_B;
  Coordinates Knifes_A;
  Coordinates Knifes_B;
  Coordinates Speed_increase_1_5_A;
  Coordinates Speed_increase_1_5_B;
  Coordinates Speed_increase_2_A;
  Coordinates Speed_increase_2_B;
  Coordinates Go_through_the_wall_A;
  Coordinates Go_through_the_wall_B;
  Coordinates Blindness_A;
  Coordinates Blindness_B;
  Coordinates Poison_A;
  Coordinates Poison_B;
  Coordinates Healing_A;
  Coordinates Healing_B;
  Coordinates Meteor_A;
  Coordinates Meteor_B;
  Coordinates MeteorRain_A;
  Coordinates MeteorRain_B;
  Coordinates Invisibility_A;
  Coordinates Invisibility_B;
  Coordinates Builder_A;
  Coordinates Builder_B;

  GameInfo({
    required this.scrolOwner,
    required this.Teleport_A,
    required this.Teleport_B,
    required this.Frozen_trap_A,
    required this.Frozen_trap_B,
    required this.Bomb_A,
    required this.Bomb_B,
    required this.Knifes_A,
    required this.Knifes_B,
    required this.Speed_increase_1_5_A,
    required this.Speed_increase_1_5_B,
    required this.Speed_increase_2_A,
    required this.Speed_increase_2_B,
    required this.Go_through_the_wall_A,
    required this.Go_through_the_wall_B,
    required this.Blindness_A,
    required this.Blindness_B,
    required this.Poison_A,
    required this.Poison_B,
    required this.Healing_A,
    required this.Healing_B,
    required this.Meteor_A,
    required this.Meteor_B,
    required this.MeteorRain_A,
    required this.MeteorRain_B,
    required this.Invisibility_A,
    required this.Invisibility_B,
    required this.Builder_A,
    required this.Builder_B,
  });

  static GameInfo createEmptyGameInfo(MazeMap map) {
    return GameInfo(
      scrolOwner: 'none',
      Frozen_trap_A: Coordinates(isInit: false, row: 0, col: 0),
      Frozen_trap_B: Coordinates(isInit: false, row: 0, col: 0),
      Teleport_A: Coordinates(isInit: false, row: 0, col: 0),
      Teleport_B: Coordinates(isInit: false, row: 0, col: 0),
      Bomb_A: Coordinates(isInit: false, row: 0, col: 0),
      Bomb_B: Coordinates(isInit: false, row: 0, col: 0),
      Knifes_A: Coordinates(isInit: false, row: 0, col: 0),
      Knifes_B: Coordinates(isInit: false, row: 0, col: 0),
      Speed_increase_1_5_A: Coordinates(isInit: false, row: 0, col: 0),
      Speed_increase_1_5_B: Coordinates(isInit: false, row: 0, col: 0),
      Speed_increase_2_A: Coordinates(isInit: false, row: 0, col: 0),
      Speed_increase_2_B: Coordinates(isInit: false, row: 0, col: 0),
      Go_through_the_wall_A: Coordinates(isInit: false, row: 0, col: 0),
      Go_through_the_wall_B: Coordinates(isInit: false, row: 0, col: 0),
      Blindness_A: Coordinates(isInit: false, row: 0, col: 0),
      Blindness_B: Coordinates(isInit: false, row: 0, col: 0),
      Poison_A: Coordinates(isInit: false, row: 0, col: 0),
      Poison_B: Coordinates(isInit: false, row: 0, col: 0),
      Healing_A: Coordinates(isInit: false, row: 0, col: 0),
      Healing_B: Coordinates(isInit: false, row: 0, col: 0),
      Meteor_A: Coordinates(isInit: false, row: 0, col: 0),
      Meteor_B: Coordinates(isInit: false, row: 0, col: 0),
      MeteorRain_A: Coordinates(isInit: false, row: 0, col: 0),
      MeteorRain_B: Coordinates(isInit: false, row: 0, col: 0),
      Invisibility_A: Coordinates(isInit: false, row: 0, col: 0),
      Invisibility_B: Coordinates(isInit: false, row: 0, col: 0),
      Builder_A: Coordinates(isInit: false, row: 0, col: 0),
      Builder_B: Coordinates(isInit: false, row: 0, col: 0),
    );
  }

  static GameInfo reverseGameInfo(GameInfo info, MazeMap map) {
        if (info.Frozen_trap_A.isInit) {
            info.Frozen_trap_A = Coordinates(
                isInit: info.Frozen_trap_A.isInit,
                row: (map.mazeMap.length - 1) - info.Frozen_trap_A.row,
                col: (map.mazeMap[0].length - 1) - info.Frozen_trap_A.col);
        }
        if (info.Teleport_A.isInit) {
            info.Teleport_A = Coordinates(
                isInit: info.Teleport_A.isInit,
                row: (map.mazeMap.length - 1) - info.Teleport_A.row,
                col: (map.mazeMap[0].length - 1) - info.Teleport_A.col);
        }
        if (info.Bomb_A.isInit) {
            info.Bomb_A = Coordinates(
                isInit: info.Bomb_A.isInit,
                row: (map.mazeMap.length - 1) - info.Bomb_A.row,
                col: (map.mazeMap[0].length - 1) - info.Bomb_A.col);
        }
        if (info.Knifes_A.isInit) {
            info.Knifes_A = Coordinates(
                isInit: info.Knifes_A.isInit,
                row: (map.mazeMap.length - 1) - info.Knifes_A.row,
                col: (map.mazeMap[0].length - 1) - info.Knifes_A.col);
        }
        if (info.Speed_increase_1_5_A.isInit) {
            info.Speed_increase_1_5_A = Coordinates(
                isInit: info.Speed_increase_1_5_A.isInit,
                row: (map.mazeMap.length - 1) - info.Speed_increase_1_5_A.row,
                col: (map.mazeMap[0].length - 1) - info.Speed_increase_1_5_A.col);
        }
        if (info.Speed_increase_2_A.isInit) {
            info.Speed_increase_2_A = Coordinates(
                isInit: info.Speed_increase_2_A.isInit,
                row: (map.mazeMap.length - 1) - info.Speed_increase_2_A.row,
                col: (map.mazeMap[0].length - 1) - info.Speed_increase_2_A.col);
        }
        if (info.Go_through_the_wall_A.isInit) {
            info.Go_through_the_wall_A = Coordinates(
                isInit: info.Go_through_the_wall_A.isInit,
                row: (map.mazeMap.length - 1) - info.Go_through_the_wall_A.row,
                col: (map.mazeMap[0].length - 1) - info.Go_through_the_wall_A.col);
        }
        if (info.Blindness_A.isInit) {
            info.Blindness_A = Coordinates(
                isInit: info.Blindness_A.isInit,
                row: (map.mazeMap.length - 1) - info.Blindness_A.row,
                col: (map.mazeMap[0].length - 1) - info.Blindness_A.col);
        }
        if (info.Poison_A.isInit) {
            info.Poison_A = Coordinates(
                isInit: info.Poison_A.isInit,
                row: (map.mazeMap.length - 1) - info.Poison_A.row,
                col: (map.mazeMap[0].length - 1) - info.Poison_A.col);
        }
        if (info.Healing_A.isInit) {
            info.Healing_A = Coordinates(
                isInit: info.Healing_A.isInit,
                row: (map.mazeMap.length - 1) - info.Healing_A.row,
                col: (map.mazeMap[0].length - 1) - info.Healing_A.col);
        }
        if (info.Meteor_A.isInit) {
            info.Meteor_A = Coordinates(
                isInit: info.Meteor_A.isInit,
                row: (map.mazeMap.length - 1) - info.Meteor_A.row,
                col: (map.mazeMap[0].length - 1) - info.Meteor_A.col);
        }
        if (info.MeteorRain_A.isInit) {
            info.MeteorRain_A = Coordinates(
                isInit: info.MeteorRain_A.isInit,
                row: (map.mazeMap.length - 1) - info.MeteorRain_A.row,
                col: (map.mazeMap[0].length - 1) - info.MeteorRain_A.col);
        }
        if (info.Invisibility_A.isInit) {
            info.Invisibility_A = Coordinates(
                isInit: info.Invisibility_A.isInit,
                row: (map.mazeMap.length - 1) - info.Invisibility_A.row,
                col: (map.mazeMap[0].length - 1) - info.Invisibility_A.col);
        }
        if (info.Builder_A.isInit) {
            info.Builder_A = Coordinates(
                isInit: info.Builder_A.isInit,
                row: (map.mazeMap.length - 1) - info.Builder_A.row,
                col: (map.mazeMap[0].length - 1) - info.Builder_A.col);
        }
        return info;
    }

  GameInfoCloud GameInfoToCloud(String myRole) {
    if (myRole == 'A') {
      return GameInfoCloud(
        frozen: Frozen_trap_A, 
        teleport: Teleport_A, 
        bomb: Bomb_A, 
        knifes: Knifes_A,
        speed_1: Speed_increase_1_5_A,
        speed_2: Speed_increase_2_A,
        through_wall: Go_through_the_wall_A,
        blindness: Blindness_A,
        poison: Poison_A,
        healing: Healing_A,
        meteor: Meteor_A,
        meteorRain: MeteorRain_A,
        invisibility: Invisibility_A,
        builder: Builder_A,
        );
    } else {
      return GameInfoCloud(
        frozen: Frozen_trap_B, 
        teleport: Teleport_B, 
        bomb: Bomb_B, 
        knifes: Knifes_B,
        speed_1: Speed_increase_1_5_B,
        speed_2: Speed_increase_2_B,
        through_wall: Go_through_the_wall_B,
        blindness: Blindness_B,
        poison: Poison_B,
        healing: Healing_B,
        meteor: Meteor_B,
        meteorRain: MeteorRain_B,
        invisibility: Invisibility_B,
        builder: Builder_B,
      );
    }
  }

  GameInfo copyWith({
    String? scrolOwner,
    Coordinates? Teleport_A,
    Coordinates? Teleport_B,
    Coordinates? Frozen_trap_A,
    Coordinates? Frozen_trap_B,
    Coordinates? Bomb_A,
    Coordinates? Bomb_B,
    Coordinates? Knifes_A,
    Coordinates? Knifes_B,
    Coordinates? Speed_increase_1_5_A,
    Coordinates? Speed_increase_1_5_B,
    Coordinates? Speed_increase_2_A,
    Coordinates? Speed_increase_2_B,
    Coordinates? Go_through_the_wall_A,
    Coordinates? Go_through_the_wall_B,
    Coordinates? Blindness_A,
    Coordinates? Blindness_B,
    Coordinates? Poison_A,
    Coordinates? Poison_B,
    Coordinates? Healing_A,
    Coordinates? Healing_B,
    Coordinates? Meteor_A,
    Coordinates? Meteor_B,
    Coordinates? MeteorRain_A,
    Coordinates? MeteorRain_B,
    Coordinates? Invisibility_A,
    Coordinates? Invisibility_B,
    Coordinates? Builder_A,
    Coordinates? Builder_B,
  }) {
    return GameInfo(
      scrolOwner: scrolOwner ?? this.scrolOwner,
      Teleport_A: Teleport_A ?? this.Teleport_A,
      Teleport_B: Teleport_B ?? this.Teleport_B,
      Frozen_trap_A: Frozen_trap_A ?? this.Frozen_trap_A,
      Frozen_trap_B: Frozen_trap_B ?? this.Frozen_trap_B,
      Bomb_A: Bomb_A ?? this.Bomb_A,
      Bomb_B: Bomb_B ?? this.Bomb_B,
      Knifes_A: Knifes_A ?? this.Knifes_A,
      Knifes_B: Knifes_B ?? this.Knifes_B,
      Speed_increase_1_5_A: Speed_increase_1_5_A ?? this.Speed_increase_1_5_A,
      Speed_increase_1_5_B: Speed_increase_1_5_B ?? this.Speed_increase_1_5_B,
      Speed_increase_2_A: Speed_increase_2_A ?? this.Speed_increase_2_A,
      Speed_increase_2_B: Speed_increase_2_B ?? this.Speed_increase_2_B,
      Go_through_the_wall_A: Go_through_the_wall_A ?? this.Go_through_the_wall_A,
      Go_through_the_wall_B: Go_through_the_wall_B ?? this.Go_through_the_wall_B,
      Blindness_A: Blindness_A ?? this.Blindness_A,
      Blindness_B: Blindness_B ?? this.Blindness_B,
      Poison_A: Poison_A ?? this.Poison_A,
      Poison_B: Poison_B ?? this.Poison_B,
      Healing_A: Healing_A ?? this.Healing_A,
      Healing_B: Healing_B ?? this.Healing_B,
      Meteor_A: Meteor_A ?? this.Meteor_A,
      Meteor_B: Meteor_B ?? this.Meteor_B,
      MeteorRain_A: MeteorRain_A ?? this.MeteorRain_A,
      MeteorRain_B: MeteorRain_B ?? this.MeteorRain_B,
      Invisibility_A: Invisibility_A ?? this.Invisibility_A,
      Invisibility_B: Invisibility_B ?? this.Invisibility_B,
      Builder_A: Builder_A ?? this.Builder_A,
      Builder_B: Builder_B ?? this.Builder_B,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scrolOwner': scrolOwner,
      'Teleport_A': Teleport_A.toMap(),
      'Teleport_B': Teleport_B.toMap(),
      'Frozen_trap_A': Frozen_trap_A.toMap(),
      'Frozen_trap_B': Frozen_trap_B.toMap(),
      'Bomb_A': Bomb_A.toMap(),
      'Bomb_B': Bomb_B.toMap(),
      'Knifes_A': Knifes_A.toMap(),
      'Knifes_B': Knifes_B.toMap(),
      'Speed_increase_1_5_A': Speed_increase_1_5_A.toMap(),
      'Speed_increase_1_5_B': Speed_increase_1_5_B.toMap(),
      'Speed_increase_2_A': Speed_increase_2_A.toMap(),
      'Speed_increase_2_B': Speed_increase_2_B.toMap(),
      'Go_through_the_wall_A': Go_through_the_wall_A.toMap(),
      'Go_through_the_wall_B': Go_through_the_wall_B.toMap(),
      'Blindness_A': Blindness_A.toMap(),
      'Blindness_B': Blindness_B.toMap(),
      'Poison_A': Poison_A.toMap(),
      'Poison_B': Poison_B.toMap(),
      'Healing_A': Healing_A.toMap(),
      'Healing_B': Healing_B.toMap(),
      'Meteor_A': Meteor_A.toMap(),
      'Meteor_B': Meteor_B.toMap(),
      'MeteorRain_A': MeteorRain_A.toMap(),
      'MeteorRain_B': MeteorRain_B.toMap(),
      'Invisibility_A': Invisibility_A.toMap(),
      'Invisibility_B': Invisibility_B.toMap(),
      'Builder_A': Builder_A.toMap(),
      'Builder_B': Builder_B.toMap(),
    };
  }

  factory GameInfo.fromMap(Map<String, dynamic> map) {
    return GameInfo(
      scrolOwner: map['scrolOwner'] as String,
      Teleport_A: Coordinates.fromMap(map['Teleport_A'] as Map<String,dynamic>),
      Teleport_B: Coordinates.fromMap(map['Teleport_B'] as Map<String,dynamic>),
      Frozen_trap_A: Coordinates.fromMap(map['Frozen_trap_A'] as Map<String,dynamic>),
      Frozen_trap_B: Coordinates.fromMap(map['Frozen_trap_B'] as Map<String,dynamic>),
      Bomb_A: Coordinates.fromMap(map['Bomb_A'] as Map<String,dynamic>),
      Bomb_B: Coordinates.fromMap(map['Bomb_B'] as Map<String,dynamic>),
      Knifes_A: Coordinates.fromMap(map['Knifes_A'] as Map<String,dynamic>),
      Knifes_B: Coordinates.fromMap(map['Knifes_B'] as Map<String,dynamic>),
      Speed_increase_1_5_A: Coordinates.fromMap(map['Speed_increase_1_5_A'] as Map<String,dynamic>),
      Speed_increase_1_5_B: Coordinates.fromMap(map['Speed_increase_1_5_B'] as Map<String,dynamic>),
      Speed_increase_2_A: Coordinates.fromMap(map['Speed_increase_2_A'] as Map<String,dynamic>),
      Speed_increase_2_B: Coordinates.fromMap(map['Speed_increase_2_B'] as Map<String,dynamic>),
      Go_through_the_wall_A: Coordinates.fromMap(map['Go_through_the_wall_A'] as Map<String,dynamic>),
      Go_through_the_wall_B: Coordinates.fromMap(map['Go_through_the_wall_B'] as Map<String,dynamic>),
      Blindness_A: Coordinates.fromMap(map['Blindness_A'] as Map<String,dynamic>),
      Blindness_B: Coordinates.fromMap(map['Blindness_B'] as Map<String,dynamic>),
      Poison_A: Coordinates.fromMap(map['Poison_A'] as Map<String,dynamic>),
      Poison_B: Coordinates.fromMap(map['Poison_B'] as Map<String,dynamic>),
      Healing_A: Coordinates.fromMap(map['Healing_A'] as Map<String,dynamic>),
      Healing_B: Coordinates.fromMap(map['Healing_B'] as Map<String,dynamic>),
      Meteor_A: Coordinates.fromMap(map['Meteor_A'] as Map<String,dynamic>),
      Meteor_B: Coordinates.fromMap(map['Meteor_B'] as Map<String,dynamic>),
      MeteorRain_A: Coordinates.fromMap(map['MeteorRain_A'] as Map<String,dynamic>),
      MeteorRain_B: Coordinates.fromMap(map['MeteorRain_B'] as Map<String,dynamic>),
      Invisibility_A: Coordinates.fromMap(map['Invisibility_A'] as Map<String,dynamic>),
      Invisibility_B: Coordinates.fromMap(map['Invisibility_B'] as Map<String,dynamic>),
      Builder_A: Coordinates.fromMap(map['Builder_A'] as Map<String,dynamic>),
      Builder_B: Coordinates.fromMap(map['Builder_B'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameInfo.fromJson(String source) =>
      GameInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameInfo(scrolOwner: $scrolOwner, Teleport_A: $Teleport_A, Teleport_B: $Teleport_B, Frozen_trap_A: $Frozen_trap_A, Frozen_trap_B: $Frozen_trap_B, Bomb_A: $Bomb_A, Bomb_B: $Bomb_B, Knifes_A: $Knifes_A, Knifes_B: $Knifes_B, Speed_increase_1_5_A: $Speed_increase_1_5_A, Speed_increase_1_5_B: $Speed_increase_1_5_B, Speed_increase_2_A: $Speed_increase_2_A, Speed_increase_2_B: $Speed_increase_2_B, Go_through_the_wall_A: $Go_through_the_wall_A, Go_through_the_wall_B: $Go_through_the_wall_B, Blindness_A: $Blindness_A, Blindness_B: $Blindness_B, Poison_A: $Poison_A, Poison_B: $Poison_B, Healing_A: $Healing_A, Healing_B: $Healing_B, Meteor_A: $Meteor_A, Meteor_B: $Meteor_B, MeteorRain_A: $MeteorRain_A, MeteorRain_B: $MeteorRain_B, Invisibility_A: $Invisibility_A, Invisibility_B: $Invisibility_B, Builder_A: $Builder_A, Builder_B: $Builder_B)';
  }

  @override
  bool operator ==(covariant GameInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.scrolOwner == scrolOwner &&
      other.Teleport_A == Teleport_A &&
      other.Teleport_B == Teleport_B &&
      other.Frozen_trap_A == Frozen_trap_A &&
      other.Frozen_trap_B == Frozen_trap_B &&
      other.Bomb_A == Bomb_A &&
      other.Bomb_B == Bomb_B &&
      other.Knifes_A == Knifes_A &&
      other.Knifes_B == Knifes_B &&
      other.Speed_increase_1_5_A == Speed_increase_1_5_A &&
      other.Speed_increase_1_5_B == Speed_increase_1_5_B &&
      other.Speed_increase_2_A == Speed_increase_2_A &&
      other.Speed_increase_2_B == Speed_increase_2_B &&
      other.Go_through_the_wall_A == Go_through_the_wall_A &&
      other.Go_through_the_wall_B == Go_through_the_wall_B &&
      other.Blindness_A == Blindness_A &&
      other.Blindness_B == Blindness_B &&
      other.Poison_A == Poison_A &&
      other.Poison_B == Poison_B &&
      other.Healing_A == Healing_A &&
      other.Healing_B == Healing_B &&
      other.Meteor_A == Meteor_A &&
      other.Meteor_B == Meteor_B &&
      other.MeteorRain_A == MeteorRain_A &&
      other.MeteorRain_B == MeteorRain_B &&
      other.Invisibility_A == Invisibility_A &&
      other.Invisibility_B == Invisibility_B &&
      other.Builder_A == Builder_A &&
      other.Builder_B == Builder_B;
  }

  @override
  int get hashCode {
    return scrolOwner.hashCode ^
      Teleport_A.hashCode ^
      Teleport_B.hashCode ^
      Frozen_trap_A.hashCode ^
      Frozen_trap_B.hashCode ^
      Bomb_A.hashCode ^
      Bomb_B.hashCode ^
      Knifes_A.hashCode ^
      Knifes_B.hashCode ^
      Speed_increase_1_5_A.hashCode ^
      Speed_increase_1_5_B.hashCode ^
      Speed_increase_2_A.hashCode ^
      Speed_increase_2_B.hashCode ^
      Go_through_the_wall_A.hashCode ^
      Go_through_the_wall_B.hashCode ^
      Blindness_A.hashCode ^
      Blindness_B.hashCode ^
      Poison_A.hashCode ^
      Poison_B.hashCode ^
      Healing_A.hashCode ^
      Healing_B.hashCode ^
      Meteor_A.hashCode ^
      Meteor_B.hashCode ^
      MeteorRain_A.hashCode ^
      MeteorRain_B.hashCode ^
      Invisibility_A.hashCode ^
      Invisibility_B.hashCode ^
      Builder_A.hashCode ^
      Builder_B.hashCode;
  }
}
