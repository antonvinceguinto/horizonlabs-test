import 'package:flutter/material.dart';
import 'package:horizonlabs_exam/src/features/movie_details/movie_details.dart';
import 'package:horizonlabs_exam/src/models/movie.dart';

class MovieItem extends StatelessWidget {
  const MovieItem(
    this.movie, {
    super.key,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          MovieDetails.routeName,
          arguments: movie,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Image.network(
            //   movie.fullImageUrl,
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            // ),
            Text('test'),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 0.9],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        movie.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${movie.voteAverage}/10',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
