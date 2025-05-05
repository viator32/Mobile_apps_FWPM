import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/movie_bloc.dart';
import '../../bloc/movie_event.dart';
import '../../bloc/movie_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_indicator.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(MovieFetched());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<MovieBloc>().add(MovieFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final max = _scrollController.position.maxScrollExtent;
    final pos = _scrollController.position.pixels;
    return pos >= (max * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        switch (state.status) {
          case MovieStatus.failure:
            return const Center(child: Text('Failed to fetch movies'));
          case MovieStatus.success:
            if (state.movies.isEmpty) {
              return const Center(child: Text('No movies'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount:
                  state.hasReachedMax
                      ? state.movies.length
                      : state.movies.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return LoadingIndicator();
                }
                return MovieCard(movie: state.movies[index]);
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
