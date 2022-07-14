import 'package:horizonlabs_exam/src/models/movie.dart';

abstract class ISort {
  Future<List<Movie>> getUpcomingMovies();
  String getGenreType(int genreId);
}
