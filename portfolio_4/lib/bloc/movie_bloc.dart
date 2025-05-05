import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../repository/movie_repository.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  static const int _limit = 20;
  int _page = 0;

  MovieBloc({required this.repository}) : super(const MovieState()) {
    on<MovieFetched>(_onMovieFetched);
  }

  Future<void> _onMovieFetched(
    MovieFetched event,
    Emitter<MovieState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MovieStatus.initial) {
        final movies = await repository.fetchMovies(page: 0, limit: _limit);
        emit(
          state.copyWith(
            status: MovieStatus.success,
            movies: movies,
            hasReachedMax: movies.length < _limit,
          ),
        );
        _page = 1;
      } else {
        final movies = await repository.fetchMovies(page: _page, limit: _limit);
        emit(
          movies.isEmpty
              ? state.copyWith(hasReachedMax: true)
              : state.copyWith(
                status: MovieStatus.success,
                movies: List.of(state.movies)..addAll(movies),
                hasReachedMax: movies.length < _limit,
              ),
        );
        _page++;
      }
    } catch (_) {
      emit(state.copyWith(status: MovieStatus.failure));
    }
  }
}
