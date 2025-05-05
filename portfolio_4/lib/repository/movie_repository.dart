import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieRepository {
  final String baseUrl;
  MovieRepository({required this.baseUrl});

  Future<List<Movie>> fetchMovies({required int page, int limit = 20}) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Error fetching movies');
    }
    final all =
        (jsonDecode(response.body) as List)
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
    final start = page * limit;
    return all.skip(start).take(limit).toList();
  }
}
