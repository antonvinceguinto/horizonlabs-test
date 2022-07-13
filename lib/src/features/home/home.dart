import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/search_field.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/horizontal_movie_container.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/now_showing_carousel.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/upcoming_movies.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie/movie_service.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  List<DragAndDropList> _draggableMovies = [];

  void _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedItem =
          _draggableMovies[oldListIndex].children.removeAt(oldItemIndex);
      _draggableMovies[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = _draggableMovies.removeAt(oldListIndex);
      _draggableMovies.insert(newListIndex, movedList);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ref.watch(themeControllerProvider.notifier);

    _draggableMovies = [
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(height: 0),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const NowShowingCarousel(),
          ),
        ],
      ),
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(height: 0),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: HorizontalMovieContainer(
              futureProvider: popularMoviesFutureProvider,
              headerTitle: 'Popular',
            ),
          ),
        ],
      ),
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(height: 0),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const UpcomingMovies(),
          ),
        ],
      ),
    ];

    return CupertinoPageScaffold(
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: CupertinoSliverNavigationBar(
                largeTitle: const Text('Horizon Movies'),
                trailing: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () async {
                      await themeController.updateThemeMode();
                    },
                    child: ref.watch(isDarkTheme)
                        ? const Icon(
                            Icons.light_mode,
                            size: 28,
                          )
                        : const Icon(
                            Icons.brightness_3,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Material(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: StickyHeader(
                header: const Padding(
                  padding: EdgeInsets.only(top: 40),
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
                  ],
                ),
                // DragAndDropLists(
                //   disableScrolling: true,
                //   onListReorder: _onListReorder,
                //   onItemReorder: _onItemReorder,
                //   children: _draggableMovies,
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
