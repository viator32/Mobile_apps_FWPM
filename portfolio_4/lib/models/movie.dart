class Movie {
  final String title;
  final String year;
  final String genre;
  final String director;

  // everything below can be missing or "N/A"
  final String? rated;
  final String? released;
  final String? runtime;
  final String? plot;
  final String? posterUrl;
  final String? imdbRating;
  final String? imdbVotes;
  final String? totalSeasons;
  final List<String> images;

  Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.director,
    this.rated,
    this.released,
    this.runtime,
    this.plot,
    this.posterUrl,
    this.imdbRating,
    this.imdbVotes,
    this.totalSeasons,
    required this.images,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // helper: turn missing or "N/A" into null
    String? parse(String key) {
      final v = json[key];
      if (v == null || v == 'N/A') return null;
      return v as String;
    }

    List<String> imgs = [];
    if (json['Images'] is List) {
      imgs =
          (json['Images'] as List)
              .whereType<String>()
              .where((s) => s.isNotEmpty)
              .toList();
    }

    return Movie(
      title: json['Title'] as String,
      year: json['Year'] as String,
      genre: json['Genre'] as String,
      director: json['Director'] as String,
      rated: parse('Rated'),
      released: parse('Released'),
      runtime: parse('Runtime'),
      plot: parse('Plot'),
      posterUrl: parse('Poster'),
      imdbRating: parse('imdbRating'),
      imdbVotes: parse('imdbVotes'),
      totalSeasons: parse('totalSeasons'),
      images: imgs,
    );
  }
}
