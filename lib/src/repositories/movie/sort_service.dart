import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/environment_config.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';
import 'package:horizonlabs_exam/src/repositories/movie/sort_interface.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

enum GenreType {
  action,
  adventure,
  animation,
  comedy,
  crime,
  documentary,
  drama,
  family,
  fantasy,
  history,
  horror,
  music,
  mystery,
  romance,
  scienceFiction,
  tvMovie,
  thriller,
  war,
  western,
}

class SortService extends ISort {
  SortService({
    required this.environmentConfig,
    required this.dio,
  });

  final EnvironmentConfig environmentConfig;
  final Dio dio;

  final String baseUrl = 'https://api.themoviedb.org/3';

  @override
  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '$baseUrl/movie/upcoming',
        queryParameters: {
          'api_key': environmentConfig.movieApiKey,
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
  String getGenreType(int genreId) {
    switch (genreId) {
      case 28:
        return GenreType.action.name;
      case 12:
        return GenreType.adventure.name;
      case 16:
        return GenreType.animation.name;
      case 35:
        return GenreType.comedy.name;
      case 80:
        return GenreType.crime.name;
      case 99:
        return GenreType.documentary.name;
      case 18:
        return GenreType.drama.name;
      case 10751:
        return GenreType.family.name;
      case 14:
        return GenreType.fantasy.name;
      case 36:
        return GenreType.history.name;
      case 27:
        return GenreType.horror.name;
      case 10402:
        return GenreType.music.name;
      case 9648:
        return GenreType.mystery.name;
      case 10749:
        return GenreType.romance.name;
      case 878:
        return GenreType.scienceFiction.name;
      case 10770:
        return GenreType.tvMovie.name;
      case 53:
        return GenreType.thriller.name;
      case 10752:
        return GenreType.war.name;
      case 37:
        return GenreType.western.name;
      default:
        return 'Unknown';
    }
  }
}

/// Provider for Genre Service
final sortServiceProvider = Provider<SortService>(
  (ref) => SortService(
    environmentConfig: ref.watch(environmentConfigProvider),
    dio: ref.watch(dioProvider),
  ),
);

final genreSortProvider = StateProvider<GenreType>(
  // We return the default sort type
  (ref) => GenreType.action,
);

final getGenreProvider = Provider<GenreType>((ref) {
  final genreType = ref.read(genreSortProvider);
  return genreType;
});

/// Provider for sorted upcoming movies
final sortedUpcomingMoviesProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  final sortType = ref.watch(genreSortProvider);

  final movies = await ref.watch(sortServiceProvider).getUpcomingMovies();

  // Sort the movies by the sort type.
  final sortedMovies = movies.where((movie) {
    switch (sortType) {
      case GenreType.action:
        return movie.genreIds!.contains(28);
      case GenreType.adventure:
        return movie.genreIds!.contains(12);
      case GenreType.animation:
        return movie.genreIds!.contains(16);
      case GenreType.comedy:
        return movie.genreIds!.contains(35);
      case GenreType.crime:
        return movie.genreIds!.contains(80);
      case GenreType.documentary:
        return movie.genreIds!.contains(99);
      case GenreType.drama:
        return movie.genreIds!.contains(18);
      case GenreType.family:
        return movie.genreIds!.contains(10751);
      case GenreType.fantasy:
        return movie.genreIds!.contains(14);
      case GenreType.history:
        return movie.genreIds!.contains(36);
      case GenreType.horror:
        return movie.genreIds!.contains(27);
      case GenreType.music:
        return movie.genreIds!.contains(10402);
      case GenreType.mystery:
        return movie.genreIds!.contains(9648);
      case GenreType.romance:
        return movie.genreIds!.contains(10749);
      case GenreType.scienceFiction:
        return movie.genreIds!.contains(878);
      case GenreType.tvMovie:
        return movie.genreIds!.contains(10770);
      case GenreType.thriller:
        return movie.genreIds!.contains(53);
      case GenreType.war:
        return movie.genreIds!.contains(10752);
      case GenreType.western:
        return movie.genreIds!.contains(37);
    }
  }).toList(growable: false);

  return sortedMovies;
});
