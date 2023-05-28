// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Node {
  int row;
  int col;
  bool wall;
  bool isShaddow;
  bool isShadowCorner;
  bool editAlowd;
  bool is_A_START;
  bool is_B_START;
  Node({
    required this.row,
    required this.col,
    required this.wall,
    required this.isShaddow,
    required this.isShadowCorner,
    required this.editAlowd,
    required this.is_A_START,
    required this.is_B_START,
  });
  

  Node copyWith({
    int? row,
    int? col,
    bool? wall,
    bool? isShaddow,
    bool? isShadowCorner,
    bool? editAlowd,
    bool? is_A_START,
    bool? is_B_START,
  }) {
    return Node(
      row: row ?? this.row,
      col: col ?? this.col,
      wall: wall ?? this.wall,
      isShaddow: isShaddow ?? this.isShaddow,
      isShadowCorner: isShadowCorner ?? this.isShadowCorner,
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
      'isShadowCorner': isShadowCorner,
      'editAlowd': editAlowd,
      'is_A_START': is_A_START,
      'is_B_START': is_B_START,
    };
  }

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      row: map['row'] as int,
      col: map['col'] as int,
      wall: map['wall'] as bool,
      isShaddow: map['isShaddow'] as bool,
      isShadowCorner: map['isShadowCorner'] as bool,
      editAlowd: map['editAlowd'] as bool,
      is_A_START: map['is_A_START'] as bool,
      is_B_START: map['is_B_START'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Node.fromJson(String source) => Node.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Node(row: $row, col: $col, wall: $wall, isShaddow: $isShaddow, isShadowCorner: $isShadowCorner, editAlowd: $editAlowd, is_A_START: $is_A_START, is_B_START: $is_B_START)';
  }

  @override
  bool operator ==(covariant Node other) {
    if (identical(this, other)) return true;
  
    return 
      other.row == row &&
      other.col == col &&
      other.wall == wall &&
      other.isShaddow == isShaddow &&
      other.isShadowCorner == isShadowCorner &&
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
      isShadowCorner.hashCode ^
      editAlowd.hashCode ^
      is_A_START.hashCode ^
      is_B_START.hashCode;
  }
}
