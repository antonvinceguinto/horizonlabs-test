import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/movie_details/movie_details.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie/sort_service.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

class UpcomingMovies extends ConsumerWidget {
  const UpcomingMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 22,
            left: 16,
            right: 16,
            bottom: 8,
          ),
          child: Text(
            'Upcoming',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: GenreType.values.length,
            itemBuilder: (context, index) {
              final genreType = GenreType.values[index];
              return Container(
                padding: const EdgeInsets.only(left: 6),
                child: ActionChip(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: ref.watch(isDarkTheme)
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor:
                      ref.watch(genreSortProvider).name == genreType.name
                          ? Colors.orange.shade400
                          : ref.watch(isDarkTheme)
                              ? Colors.black
                              : Colors.white,
                  onPressed: () {
                    ref.read(genreSortProvider.notifier).state = genreType;
                  },
                  padding: const EdgeInsets.all(6),
                  label: Text(
                    genreType.name.toUpperCase(),
                  ),
                ),
              );
            },
          ),
        ),
        ref.watch(sortedUpcomingMoviesProvider).when(
              data: (movies) {
                if (movies.isEmpty) {
                  return Center(
                    child: Text(
                      '''
No upcoming movies for ${ref.watch(genreSortProvider).name}
                      ''',
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        bottom: 8,
                        top: 8,
                      ),
                      child: Text(
                        'Re-orderable list',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) {
                        movies.insert(
                          newIndex,
                          movies.removeAt(
                            oldIndex,
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return Container(
                          key: Key(movie.id.toString()),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ref.watch(isDarkTheme)
                                ? Colors.black
                                : Colors.grey.shade200,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MovieDetails.routeName,
                                arguments: movie,
                              );
                            },
                            title: Text(
                              movie.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Text(
                              movie.overview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text('⭐️ ${movie.voteAverage}'),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                movie.fullBackdropImageUrl,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
              loading: () => const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
      ],
    );
  }
}
