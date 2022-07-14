import 'dart:convert';
import 'package:flutter/material.dart';

@immutable
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title']?.toString() ?? '',
      posterPath: map['poster_path']?.toString() ?? '',
      backdropPath: map['backdrop_path']?.toString() ?? '',
      overview: map['overview']?.toString() ?? '',
      releaseDate: map['release_date']?.toString() ?? '',
      voteAverage: double.tryParse(map['vote_average'].toString()) ?? 0,
      genreIds: map['genre_ids'].cast<int>() as List<int>,
    );
  }

  String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$posterPath';
  String get fullImageUrlHD => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropImageUrl =>
      'https://image.tmdb.org/t/p/w500$backdropPath';

  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final List<int>? genreIds;
}
