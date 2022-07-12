import 'package:horizonlabs_exam/src/models/movie.dart';

abstract class IMovie {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getNowShowingMovies();
  Future<List<Movie>> getUpcomingMovies();
}
