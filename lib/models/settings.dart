// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  GlobalSettings({
    required this.default_health,
    required this.default_shaddow_radius,
    required this.shaddow_radius_with_buf,
    required this.speed_1,
    required this.speed_2,
    required this.speed_3,
    required this.timer_back_for_battle,
    required this.timer_back_for_training,
  });

  static GlobalSettings fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions options) {
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
  );
}

static Map<String, dynamic> toFirestore(GlobalSettings settings, SetOptions options) {
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
}
