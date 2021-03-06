import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/widgets/discover/movie_element.dart';

class MoviesGrid extends StatefulWidget {
  MoviesGrid({Key key}) : super(key: key);

  @override
  _MoviesGridState createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      // ignore: missing_return
      builder: (context, state) {
        print("In bloc builder");
        if (state is MoviesSearchLoadInProgressState ||
            state is MoviesSearchInitialState) {
          return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()));
        }
        if (state is MoviesSearchLoadSuccess) {
          final movies = state.movies;
          print("Movie Loaded");
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 300.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => GridMovieElement(
                  index: index,
                  result: movies[index],
                  isFav: false,
                  posterURL: movies[index].posterPath,
                  title: movies[index].title),
              childCount: state.totalMovies,
            ),
          );
        }
        if (state is MoviesSearchLoadFailureState) {
          return SliverFillRemaining(
              child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.adb_sharp,
                    color: Colors.red,
                  ),
                  Text(
                    'Oops! Something went wrong!',
                    style: TextStyle(color: Colors.red),
                  )
                ]),
          ));
        }
      },
    );
  }
}
