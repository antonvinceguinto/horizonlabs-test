import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

class RefWatch extends ConsumerWidget {
  const RefWatch({
    super.key,
    required this.futureProvider,
    required this.children,
  });

  final AutoDisposeFutureProvider<List<Movie>> futureProvider;
  final Widget Function(List<Movie>) children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(futureProvider).when(
          data: children,
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
        );
  }
}
