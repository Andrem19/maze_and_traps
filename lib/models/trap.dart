// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Trap {
  String name;
  String description;
  int damage;
  int baff;
  String img;
  int cost;
  int weight;
  Trap({
    required this.name,
    required this.description,
    required this.damage,
    required this.baff,
    required this.img,
    required this.cost,
    required this.weight,
  });

  Trap copyWith({
    String? name,
    String? description,
    int? damage,
    int? baff,
    String? img,
    int? cost,
    int? weight,
  }) {
    return Trap(
      name: name ?? this.name,
      description: description ?? this.description,
      damage: damage ?? this.damage,
      baff: baff ?? this.baff,
      img: img ?? this.img,
      cost: cost ?? this.cost,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'damage': damage,
      'baff': baff,
      'img': img,
      'cost': cost,
      'weight': weight,
    };
  }

  factory Trap.fromMap(Map<String, dynamic> map) {
    return Trap(
      name: map['name'] as String,
      description: map['description'] as String,
      damage: map['damage'] as int,
      baff: map['baff'] as int,
      img: map['img'] as String,
      cost: map['cost'] as int,
      weight: map['weight'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Trap.fromJson(String source) => Trap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Trap(name: $name, description: $description, damage: $damage, baff: $baff, img: $img, cost: $cost, weight: $weight)';
  }

  @override
  bool operator ==(covariant Trap other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description &&
      other.damage == damage &&
      other.baff == baff &&
      other.img == img &&
      other.cost == cost &&
      other.weight == weight;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      description.hashCode ^
      damage.hashCode ^
      baff.hashCode ^
      img.hashCode ^
      cost.hashCode ^
      weight.hashCode;
  }
}
