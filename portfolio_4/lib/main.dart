import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/movie_repository.dart';
import 'bloc/movie_bloc.dart';
import 'ui/screens/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = MovieRepository(
      baseUrl:
          'https://670ef2d6-dbdd-454c-b4d7-6960afb18cc2.mock.pstmn.io/movies',
    );

    return MaterialApp(
      title: 'Movie Portfolio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RepositoryProvider.value(
        value: repo,
        child: BlocProvider(
          create: (_) => MovieBloc(repository: repo),
          child: MovieListScreen(),
        ),
      ),
    );
  }
}
