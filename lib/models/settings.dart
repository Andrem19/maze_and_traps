// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalSettings {
  int default_health;
  int default_shaddow_radius;
  int shaddow_radius_with_buf;
  int speed_1;
  int speed_2;
  int speed_3;
  int timer_back_for_battle;
  int timer_back_for_training;
  int adInterval;
  GlobalSettings({
    required this.default_health,
    required this.default_shaddow_radius,
    required this.shaddow_radius_with_buf,
    required this.speed_1,
    required this.speed_2,
    required this.speed_3,
    required this.timer_back_for_battle,
    required this.timer_back_for_training,
    required this.adInterval,
  });

  static GlobalSettings fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final Map<String, dynamic> data = snapshot.data() ?? {};
    // Parse the data and return a new Settings object
    return GlobalSettings(
      default_health: data['default_health'] as int? ?? 0,
      default_shaddow_radius: data['default_shaddow_radius'] as int? ?? 0,
      shaddow_radius_with_buf: data['shaddow_radius_with_buf'] as int? ?? 0,
      speed_1: data['speed_1'] as int? ?? 0,
      speed_2: data['speed_2'] as int? ?? 0,
      speed_3: data['speed_3'] as int? ?? 0,
      timer_back_for_battle: data['timer_back_for_battle'] as int? ?? 0,
      timer_back_for_training: data['timer_back_for_training'] as int? ?? 0,
      adInterval: data['adInterval'] as int? ?? 0,
    );
  }

  static Map<String, dynamic> toFirestore(
      GlobalSettings settings, SetOptions options) {
    // Convert the Settings object back into a map
    return {
      'default_health': settings.default_health,
      'default_shaddow_radius': settings.default_shaddow_radius,
      'shaddow_radius_with_buf': settings.shaddow_radius_with_buf,
      'speed_1': settings.speed_1,
      'speed_2': settings.speed_2,
      'speed_3': settings.speed_3,
      'timer_back_for_battle': settings.timer_back_for_battle,
      'timer_back_for_training': settings.timer_back_for_training,
    };
  }

  GlobalSettings copyWith({
    int? default_health,
    int? default_shaddow_radius,
    int? shaddow_radius_with_buf,
    int? speed_1,
    int? speed_2,
    int? speed_3,
    int? timer_back_for_battle,
    int? timer_back_for_training,
    int? adInterval,
  }) {
    return GlobalSettings(
      default_health: default_health ?? this.default_health,
      default_shaddow_radius: default_shaddow_radius ?? this.default_shaddow_radius,
      shaddow_radius_with_buf: shaddow_radius_with_buf ?? this.shaddow_radius_with_buf,
      speed_1: speed_1 ?? this.speed_1,
      speed_2: speed_2 ?? this.speed_2,
      speed_3: speed_3 ?? this.speed_3,
      timer_back_for_battle: timer_back_for_battle ?? this.timer_back_for_battle,
      timer_back_for_training: timer_back_for_training ?? this.timer_back_for_training,
      adInterval: adInterval ?? this.adInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'default_health': default_health,
      'default_shaddow_radius': default_shaddow_radius,
      'shaddow_radius_with_buf': shaddow_radius_with_buf,
      'speed_1': speed_1,
      'speed_2': speed_2,
      'speed_3': speed_3,
      'timer_back_for_battle': timer_back_for_battle,
      'timer_back_for_training': timer_back_for_training,
      'adInterval': adInterval,
    };
  }

  factory GlobalSettings.fromMap(Map<String, dynamic> map) {
    return GlobalSettings(
      default_health: map['default_health'] as int,
      default_shaddow_radius: map['default_shaddow_radius'] as int,
      shaddow_radius_with_buf: map['shaddow_radius_with_buf'] as int,
      speed_1: map['speed_1'] as int,
      speed_2: map['speed_2'] as int,
      speed_3: map['speed_3'] as int,
      timer_back_for_battle: map['timer_back_for_battle'] as int,
      timer_back_for_training: map['timer_back_for_training'] as int,
      adInterval: map['adInterval'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalSettings.fromJson(String source) =>
      GlobalSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GlobalSettings(default_health: $default_health, default_shaddow_radius: $default_shaddow_radius, shaddow_radius_with_buf: $shaddow_radius_with_buf, speed_1: $speed_1, speed_2: $speed_2, speed_3: $speed_3, timer_back_for_battle: $timer_back_for_battle, timer_back_for_training: $timer_back_for_training, adInterval: $adInterval)';
  }

  @override
  bool operator ==(covariant GlobalSettings other) {
    if (identical(this, other)) return true;
  
    return 
      other.default_health == default_health &&
      other.default_shaddow_radius == default_shaddow_radius &&
      other.shaddow_radius_with_buf == shaddow_radius_with_buf &&
      other.speed_1 == speed_1 &&
      other.speed_2 == speed_2 &&
      other.speed_3 == speed_3 &&
      other.timer_back_for_battle == timer_back_for_battle &&
      other.timer_back_for_training == timer_back_for_training &&
      other.adInterval == adInterval;
  }

  @override
  int get hashCode {
    return default_health.hashCode ^
      default_shaddow_radius.hashCode ^
      shaddow_radius_with_buf.hashCode ^
      speed_1.hashCode ^
      speed_2.hashCode ^
      speed_3.hashCode ^
      timer_back_for_battle.hashCode ^
      timer_back_for_training.hashCode ^
      adInterval.hashCode;
  }
}
