// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class NodeCube {
  int row;
  int col;
  bool wall;
  bool isShaddow;
  bool halfShaddow;
  bool editAlowd;
  bool is_A_START;
  bool is_B_START;
  Widget Function()? additionalStuff;
  NodeCube({
    required this.row,
    required this.col,
    required this.wall,
    required this.isShaddow,
    required this.halfShaddow,
    required this.editAlowd,
    required this.is_A_START,
    required this.is_B_START,
  });
  

  NodeCube copyWith({
    int? row,
    int? col,
    bool? wall,
    bool? isShaddow,
    bool? halfShaddow,
    bool? editAlowd,
    bool? is_A_START,
    bool? is_B_START,
  }) {
    return NodeCube(
      row: row ?? this.row,
      col: col ?? this.col,
      wall: wall ?? this.wall,
      isShaddow: isShaddow ?? this.isShaddow,
      halfShaddow: halfShaddow ?? this.halfShaddow,
      editAlowd: editAlowd ?? this.editAlowd,
      is_A_START: is_A_START ?? this.is_A_START,
      is_B_START: is_B_START ?? this.is_B_START,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'row': row,
      'col': col,
      'wall': wall,
      'isShaddow': isShaddow,
      'halfShaddow': halfShaddow,
      'editAlowd': editAlowd,
      'is_A_START': is_A_START,
      'is_B_START': is_B_START,
    };
  }

  factory NodeCube.fromMap(Map<String, dynamic> map) {
    return NodeCube(
      row: map['row'] as int,
      col: map['col'] as int,
      wall: map['wall'] as bool,
      isShaddow: map['isShaddow'] as bool,
      halfShaddow: map['halfShaddow'] as bool,
      editAlowd: map['editAlowd'] as bool,
      is_A_START: map['is_A_START'] as bool,
      is_B_START: map['is_B_START'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory NodeCube.fromJson(String source) => NodeCube.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NodeCube(row: $row, col: $col, wall: $wall, isShaddow: $isShaddow, halfShaddow: $halfShaddow, editAlowd: $editAlowd, is_A_START: $is_A_START, is_B_START: $is_B_START)';
  }

  @override
  bool operator ==(covariant NodeCube other) {
    if (identical(this, other)) return true;
  
    return 
      other.row == row &&
      other.col == col &&
      other.wall == wall &&
      other.isShaddow == isShaddow &&
      other.halfShaddow == halfShaddow &&
      other.editAlowd == editAlowd &&
      other.is_A_START == is_A_START &&
      other.is_B_START == is_B_START;
  }

  @override
  int get hashCode {
    return row.hashCode ^
      col.hashCode ^
      wall.hashCode ^
      isShaddow.hashCode ^
      halfShaddow.hashCode ^
      editAlowd.hashCode ^
      is_A_START.hashCode ^
      is_B_START.hashCode;
  }
}
