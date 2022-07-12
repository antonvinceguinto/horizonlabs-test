import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/features/custom_widgets/search_field.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/horizontal_movie_container.dart';
import 'package:horizonlabs_exam/src/features/home/widgets/now_showing_carousel.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';
import 'package:horizonlabs_exam/src/repositories/movie_service.dart';
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
    _draggableMovies = [
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(),
        children: [
          DragAndDropItem(
            child: const NowShowingCarousel(),
          ),
        ],
      ),
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(),
        children: [
          DragAndDropItem(
            child: HorizontalMovieContainer(
              futureProvider: popularMoviesFutureProvider,
              headerTitle: 'Popular',
            ),
          ),
        ],
      ),
      DragAndDropList(
        contentsWhenEmpty: const SizedBox(),
        children: [
          DragAndDropItem(
            child: HorizontalMovieContainer(
              futureProvider: upcomingMoviesFutureProvider,
              headerTitle: 'Upcoming',
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ref.watch(themeControllerProvider.notifier);

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
                  padding: EdgeInsets.only(top: 38),
                  child: SearchField(),
                ),
                content: Column(
                  children: [
                    DragAndDropLists(
                      listPadding: EdgeInsets.zero,
                      lastItemTargetHeight: 0,
                      disableScrolling: true,
                      onListReorder: _onListReorder,
                      onItemReorder: _onItemReorder,
                      children: _draggableMovies,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text(
                        'Horizonlabs © 2022',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
