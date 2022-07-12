import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/ref_watch.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/movie_item.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';

class HorizontalMovieContainer extends ConsumerWidget {
  const HorizontalMovieContainer({
    super.key,
    required this.futureProvider,
    required this.headerTitle,
  });

  final AutoDisposeFutureProvider<List<Movie>> futureProvider;
  final String headerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefWatch(
      futureProvider: futureProvider,
      children: (movies) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 22,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerTitle,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: GridView.extent(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              maxCrossAxisExtent: 300,
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.5,
              children: movies.map(MovieItem.new).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
