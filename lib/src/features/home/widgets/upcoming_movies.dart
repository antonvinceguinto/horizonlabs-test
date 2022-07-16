import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/movie_details/movie_details.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie/sort_service.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

class UpcomingMovies extends ConsumerStatefulWidget {
  const UpcomingMovies({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends ConsumerState<UpcomingMovies> {
  late ScrollController scrollController;

  List<DragAndDropList> contents = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget _chipGenres() {
    return SizedBox(
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
                      ? Colors.purple
                      : ref.watch(isDarkTheme)
                          ? Colors.grey.shade700
                          : Colors.white,
              onPressed: () {
                ref.read(genreSortProvider.notifier).state = genreType;
                contents.clear();
              },
              padding: const EdgeInsets.all(6),
              label: Text(
                genreType.name.toUpperCase(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _movieItem(Movie movie) {
    return Container(
      key: Key(movie.id.toString()),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
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
  }

  void _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
      contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = contents.removeAt(oldListIndex);
      contents.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        _chipGenres(),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 8,
            top: 8,
          ),
          child: Text(
            'Re-orderable & Filterable list',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        ref.watch(sortedUpcomingMoviesProvider).when(
              data: (movies) {
                if (contents.isEmpty) {
                  contents.addAll(
                    [
                      DragAndDropList(
                        header: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Top Rated'),
                              DragHandle(
                                child: Icon(Icons.drag_handle),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          for (var movie in movies) ...{
                            if (movie.voteAverage >= 6) ...{
                              DragAndDropItem(child: _movieItem(movie))
                            }
                          }
                        ],
                      ),
                      DragAndDropList(
                        header: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Less/No Ratings'),
                              DragHandle(
                                child: Icon(Icons.drag_handle),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          for (var movie in movies) ...{
                            if (movie.voteAverage < 6) ...{
                              DragAndDropItem(child: _movieItem(movie))
                            }
                          }
                        ],
                      ),
                    ],
                  );
                }

                if (movies.isEmpty) {
                  return Center(
                    child: Text(
                      '''
No upcoming movies for ${ref.watch(genreSortProvider).name}
                      ''',
                    ),
                  );
                }

                return CustomScrollView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    DragAndDropLists(
                      sliverList: true,
                      scrollController: scrollController,
                      disableScrolling: true,
                      children: contents,
                      onItemReorder: _onItemReorder,
                      onListReorder: _onListReorder,
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
