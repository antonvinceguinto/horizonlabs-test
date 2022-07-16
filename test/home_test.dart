import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/movie_item.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';
import 'package:horizonlabs_exam/src/utils/helper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'home_test.mocks.dart';

final repositoryProvider = Provider(
  (ref) => MockMovieService(),
);

final movieServiceProvider = FutureProvider((ref) async {
  final repository = ref.read(repositoryProvider);

  when(repository.getPopularMovies()).thenAnswer((_) async {
    // Fetch json file
    final jsonResponse = await Helper.readJson();

    // Convert json to a list movie object
    final res = List<Map<String, dynamic>>.from(
      jsonResponse['results'] as Iterable<dynamic>,
    );

    final movies = res.map((movieData) {
      return Movie.fromMap(movieData);
    }).toList(growable: false);

    return movies;
  });

  return repository.getPopularMovies();
});

@GenerateMocks([
  MovieService,
])
void main() async {
  group('Movie list and profile page', () {
    setUp(() async {
      /// IMPORTANT: Initialize dotenv
      TestWidgetsFlutterBinding.ensureInitialized();
      await dotenv.load();
    });

    testWidgets('should populate a listview with popular movies',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            repositoryProvider.overrideWithValue(MockMovieService()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  return ref.watch(movieServiceProvider).when(
                        data: (movies) {
                          return ListView(
                            children: [
                              for (var movie in movies) MovieItem(movie),
                            ],
                          );
                        },
                        error: (err, s) {
                          if (err is MoviesException) {
                            return Center(
                              child: Text('${err.message}'),
                            );
                          }
                          return const Center(
                            child: Text('Oops, Something went wrong'),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                      );
                },
              ),
            ),
          ),
        ),
      );

      // First frame is a loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Provider should have finished fetching the movies by now
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Expect the listview to have the movie item widget
      expect(tester.widgetList(find.byType(MovieItem)), [
        isA<MovieItem>()
            .having((s) => s.movie.id, 'movie id', 1)
            .having((s) => s.movie.title, 'movie title', 'Movie 1'),
        isA<MovieItem>()
            .having((s) => s.movie.id, 'movie id', 2)
            .having((s) => s.movie.title, 'movie title', 'Movie 2')
      ]);
    });
  });
}
