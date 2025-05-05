import 'package:flutter/material.dart';
import '../../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // ── Poster or placeholder ─────────────────────────────────
          _buildPoster(),

          // ── Info ────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 4),

                  // Year & Rated chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildChip(Icons.calendar_today, movie.year),
                      if (movie.rated != null)
                        _buildChip(Icons.shield, movie.rated!),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Genre chips
                  if (movie.genre.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children:
                          movie.genre
                              .split(', ')
                              .map(
                                (g) => Chip(
                                  label: Text(
                                    g,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.blue.shade50,
                                ),
                              )
                              .toList(),
                    ),

                  const SizedBox(height: 8),

                  // Director & Runtime
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          movie.director,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (movie.runtime != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.runtime!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  if (movie.imdbRating != null)
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.imdbRating} / 10',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (movie.imdbVotes != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '(${movie.imdbVotes} votes)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),

                  // Seasons (for series)
                  if (movie.totalSeasons != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Seasons: ${movie.totalSeasons}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    final placeholder = Container(
      width: 100,
      height: 150,
      color: Colors.grey[300],
      child: const Icon(Icons.movie, size: 48, color: Colors.white70),
    );

    if (movie.posterUrl == null) return placeholder;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Image.network(
        movie.posterUrl!,
        width: 100,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Chip(
      backgroundColor: Colors.grey.shade200,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(icon, size: 14, color: Colors.grey[700]),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
      ),
    );
  }
}
