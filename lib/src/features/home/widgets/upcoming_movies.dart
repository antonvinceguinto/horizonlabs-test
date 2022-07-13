import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/ref_watch.dart';
import 'package:horizonlabs_exam/src/features/movie_details/movie_details.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';

class UpcomingMovies extends ConsumerWidget {
  const UpcomingMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefWatch(
      futureProvider: upcomingMoviesFutureProvider,
      children: (movies) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 22,
                left: 16,
                right: 16,
              ),
              child: Text(
                'Upcoming',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return Container(
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
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
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
                        backgroundImage: NetworkImage(
                          movie.fullBackdropImageUrl,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
