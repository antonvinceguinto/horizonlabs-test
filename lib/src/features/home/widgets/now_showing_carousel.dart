import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/ref_watch.dart';
import 'package:horizonlabs_exam/src/features/movie_details/movie_details.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';
import 'package:horizonlabs_exam/src/utils/errors/movies_exception.dart';

class NowShowingCarousel extends ConsumerWidget {
  const NowShowingCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefWatch(
      futureProvider: nowShowingMoviesFutureProvider,
      children: (movies) => Column(
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
              'Now Showing',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ref.watch(nowShowingMoviesFutureProvider).when(
                data: (movies) {
                  return CarouselSlider(
                    items: movies.map(
                      (movie) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MovieDetails.routeName,
                              arguments: movie,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Image.network(
                                  movie.fullBackdropImageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  color: Colors.black.withOpacity(0.5),
                                  width: double.infinity,
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        movie.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        movie.overview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      autoPlayCurve: Curves.easeInOut,
                      aspectRatio: 2.4,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
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
      ),
    );
  }
}
