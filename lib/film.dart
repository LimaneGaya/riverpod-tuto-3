import 'package:flutter/foundation.dart';
export 'all_films.dart';

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Film(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Film copy({required bool isFavorite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }
  @override
  String toString() => 'Film(id: $id, title: '
      '$title, description: $description, '
      'isFavorite: $isFavorite)';

  @override
  bool operator ==(covariant Film other) {
    if (identical(this, other)) return true;

    return other.id == id && other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^ isFavorite.hashCode;
  }
}
