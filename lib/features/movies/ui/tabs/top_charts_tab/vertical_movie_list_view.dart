import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/locator.dart';
import '../../../../lang/cubit/lang/lang_cubit.dart';
import '../../../cubit/movie/movie_cubit.dart';
import '../../../cubit/movies/movies_cubit.dart';
import '../../../data/models/movie_model.dart';
import '../../../repositories/entities/movie_entity.dart';
import '../../../repositories/movies_repository.dart';
import '../../screens/movie_details_screen.dart';

class VerticalMovieListView extends StatelessWidget {
  final Iterable<MovieEntity> movies;
  final bool showCounter;

  const VerticalMovieListView(
      {super.key, required this.movies, this.showCounter = false});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: BlocProvider.of<MoviesCubit>(context).initLoad,
      child: ListView.separated(
        padding: const EdgeInsets.all(25),
        itemCount: movies.length,
        itemBuilder: (_, index) {
          String heroTag = const Uuid().v4();
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider<MovieCubit>(
                        create: (_) => MovieCubit(
                            moviesCubit: BlocProvider.of<MoviesCubit>(context),
                            movie: movies.elementAt(index),
                            moviesRepository:  locator<MoviesRepository>(),
                            langCubit:  BlocProvider.of<LangCubit>(context)
                        ),
                        child: MovieDetailsScreen(heroTag: heroTag),
                      )));
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCounter)
                  SizedBox(width: 25, child: Text((index + 1).toString())),
                if (showCounter) const SizedBox(width: 5),
                Hero(
                  tag: heroTag,
                  child: CachedNetworkImage(
                      imageUrl: movies.elementAt(index).smallImage),
                )
              ],
            ),
            title: Text(movies.elementAt(index).name),
            subtitle: Row(
              children: [
                Text(movies.elementAt(index).rating),
                const Icon(Icons.star, size: 14),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }
}
