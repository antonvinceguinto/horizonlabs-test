import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Genre {
  const Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(String source) =>
      Genre.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  final int id;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
