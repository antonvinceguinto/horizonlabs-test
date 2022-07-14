import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/search_field.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/horizontal_movie_container.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/now_showing_carousel.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/upcoming_movies.dart';
import 'package:horizonlabs_exam/src/features/profile/profile.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        physics: const ScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: CupertinoSliverNavigationBar(
                backgroundColor: Theme.of(context).backgroundColor,
                border: const Border(),
                largeTitle: const Text('Horizon Movies'),
                trailing: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () async {
                      await showBarModalBottomSheet<void>(
                        context: context,
                        builder: (context) => Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.65,
                          ),
                          child: const Profile(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/80',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Material(
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: StickyHeader(
              header: const Padding(
                padding: EdgeInsets.only(top: 90),
                child: SearchField(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NowShowingCarousel(),
                  HorizontalMovieContainer(
                    futureProvider: popularMoviesFutureProvider,
                    headerTitle: 'Popular',
                  ),
                  const UpcomingMovies(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
