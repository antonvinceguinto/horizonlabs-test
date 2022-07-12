import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/utils/extensions.dart';

class MovieDetails extends ConsumerWidget {
  const MovieDetails({super.key});

  static const routeName = '/movie-details';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /**
     * We passed the movie arguments from homepage to this page. 
    **/
    final movie = ModalRoute.of(context)!.settings.arguments! as Movie;
    const heightOffset = 1.7;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                movie.fullImageUrlHD,
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / heightOffset,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          movie.title,
                          textStyle:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                          colors: [
                            Colors.red,
                            Colors.purple,
                            if (ref.watch(isDarkTheme))
                              Colors.white
                            else
                              Colors.black,
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 3),
                    if (movie.voteAverage != 0) ...{
                      Text(
                        'Rating: ${movie.voteAverage}/10',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    },
                    const SizedBox(height: 3),
                    if (movie.releaseDate != '')
                      Text(
                        'Released on: ${movie.releaseDate.toDate()}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    const SizedBox(height: 8),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
