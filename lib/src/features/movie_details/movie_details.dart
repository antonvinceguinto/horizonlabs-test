import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie/sort_service.dart';
import 'package:horizonlabs_exam/src/utils/extensions.dart';

class MovieDetails extends ConsumerStatefulWidget {
  const MovieDetails({super.key});

  static const routeName = '/movie-details';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends ConsumerState<MovieDetails>
    with TickerProviderStateMixin {
  late TabController tabController;
  late ScrollController _scrollController;

  bool overviewTopSafearea = false;

  Widget _movieDetails(Movie movie) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                for (final genre in movie.genreIds!)
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: ref.watch(isDarkTheme)
                          ? Colors.black
                          : Colors.grey.shade200,
                    ),
                    child: Text(
                      ref
                          .watch(sortServiceProvider)
                          .getGenreType(genre)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  void _scroll() {
    if (_scrollController.offset > 550) {
      setState(() {
        overviewTopSafearea = true;
      });
      return;
    }

    setState(() {
      overviewTopSafearea = false;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    _scrollController = ScrollController()..addListener(_scroll);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * We passed the movie arguments from homepage to this page. 
    **/
    final movie = ModalRoute.of(context)!.settings.arguments! as Movie;
    const expandedHeightOffset = 0.6;

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          expandedHeight:
              MediaQuery.of(context).size.height * expandedHeightOffset,
          title: overviewTopSafearea ? Text(movie.title) : const SizedBox(),
          flexibleSpace: FlexibleSpaceBar(
            background: SizedBox(
              child: Image.network(
                movie.fullImageUrlHD,
                fit: BoxFit.cover,
                width: double.infinity,
                // height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        ),
      ],
      body: Material(
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              labelColor: Colors.orange.shade400,
              indicatorColor: Colors.orange.shade400,
              tabs: const [
                Tab(text: 'Overview 1'),
                Tab(text: 'Overview 2'),
                Tab(text: 'Overview 3'),
              ],
            ),
            Expanded(
              child: SafeArea(
                top: overviewTopSafearea,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _movieDetails(movie),
                    _movieDetails(movie),
                    _movieDetails(movie),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
