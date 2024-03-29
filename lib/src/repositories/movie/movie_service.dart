import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_interface.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

enum MovieType { popular, nowShowing }

class MovieService extends IMovie {
  MovieService({
    required this.dio,
  });

  final Dio dio;

  final String baseUrl = 'https://api.themoviedb.org/3';

  @override
  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '$baseUrl/movie/popular',
        queryParameters: {
          'api_key': dotenv.env['TMDB_API_KEY'],
        },
      );

      final results = List<Map<String, dynamic>>.from(
        response.data!['results'] as Iterable<dynamic>,
      );

      final movies = results.map((movieData) {
        return Movie.fromMap(movieData);
      }).toList(growable: false);

      return movies;
    } on DioError catch (dioErr) {
      throw MoviesException.fromDioError(dioErr);
    }
  }

  @override
  Future<List<Movie>> getNowShowingMovies() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '$baseUrl/movie/now_playing',
        queryParameters: {
          'api_key': dotenv.env['TMDB_API_KEY'],
        },
      );

      final results = List<Map<String, dynamic>>.from(
        response.data!['results'] as Iterable<dynamic>,
      );

      final movies = results.map((movieData) {
        return Movie.fromMap(movieData);
      }).toList(growable: false);

      return movies;
    } on DioError catch (dioErr) {
      throw MoviesException.fromDioError(dioErr);
    }
  }
}

/// Provider for Dio instance.
final dioProvider = Provider((_) => Dio());

/// Provider for MovieService.
final movieServiceProvider = Provider<MovieService>(
  (ref) => MovieService(
    dio: ref.watch(dioProvider),
  ),
);

/// FutureProvider for popular movies.
final popularMoviesFutureProvider = FutureProvider.autoDispose<List<Movie>>(
    (AutoDisposeFutureProviderRef<List<Movie>> ref) async {
  final movies = await fetchService(ref, MovieType.popular);
  return movies;
});

/// FutureProvider for now showing movies.
final nowShowingMoviesFutureProvider = FutureProvider.autoDispose<List<Movie>>(
    (AutoDisposeFutureProviderRef<List<Movie>> ref) async {
  final movies = await fetchService(ref, MovieType.nowShowing);
  return movies;
});

/// Fetches movies from the service.
Future<List<Movie>> fetchService(
  AutoDisposeFutureProviderRef<List<Movie>> ref,
  MovieType movieType,
) async {
  ref.maintainState = true;

  final movieService = ref.watch(movieServiceProvider);

  List<Movie> movies;
  switch (movieType) {
    case MovieType.popular:
      movies = await movieService.getPopularMovies();
      return movies;
    case MovieType.nowShowing:
      movies = await movieService.getNowShowingMovies();
      return movies;
  }
}
