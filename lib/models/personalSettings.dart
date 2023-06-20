// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonalSettings {
  bool showArrowControl;
  bool showHints;
  PersonalSettings({
    required this.showArrowControl,
    required this.showHints,
  });

  static PersonalSettings getEmptyPS() {
    return PersonalSettings(showArrowControl: false, showHints: true);
  }

  PersonalSettings copyWith({
    bool? showArrowControl,
    bool? showHints,
  }) {
    return PersonalSettings(
      showArrowControl: showArrowControl ?? this.showArrowControl,
      showHints: showHints ?? this.showHints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showArrowControl': showArrowControl,
      'showHints': showHints,
    };
  }

  factory PersonalSettings.fromMap(Map<String, dynamic> map) {
    return PersonalSettings(
      showArrowControl: map['showArrowControl'] as bool,
      showHints: map['showHints'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalSettings.fromJson(String source) =>
      PersonalSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PersonalSettings(showArrowControl: $showArrowControl, showHints: $showHints)';

  @override
  bool operator ==(covariant PersonalSettings other) {
    if (identical(this, other)) return true;

    return other.showArrowControl == showArrowControl &&
        other.showHints == showHints;
  }

  @override
  int get hashCode => showArrowControl.hashCode ^ showHints.hashCode;
}
