import 'package:http/http.dart' as http;
import 'dart:convert';
import 'genre.dart';
import 'movie.dart';

const token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNGQyMDIzN2JkYzc3NGJjMzY1NDg1MGQ4NDZkNTlhNCIsIm5iZiI6MTcyNTk3NzU5Ni4wMjkwNTIsInN1YiI6IjY2ZTA1MzFmNjdkZjE4NTZmMTBkOWViMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sJeTeIebfZ4lE-DjaDpuvC3Ki6nzcpEFjQjCp0ht0t4";

class MovieController {
  List<Movie>? movies;
  List<Genre>? genres;

  Future<void> fetchAndNormalizeData() async {
    genres = await fetchGenres();
    movies = await fetchMovies(genres!);
  }

  Future<List<Movie>> fetchMovies(List<Genre> genres) async {
    final url = Uri.https("api.themoviedb.org", "/3/movie/popular");

    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<Movie> movies = (data['results'] as List).map((movieData) {
          List<Genre> movieGenres = (movieData['genre_ids'] as List).map((genreId) {
            return genres.firstWhere((genre) => genre.id == genreId);
          }).toList();

          return Movie(
            movieData['title'],
            movieData['overview'],
            DateTime.parse(movieData['release_date']),
            movieGenres,
          );
        }).toList();

        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      throw Exception('Error fetching movie data: $error');
    }
  }

  Future<List<Genre>> fetchGenres() async {
    final url = Uri.https("api.themoviedb.org", "/3/genre/movie/list");

    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<Genre> genres = (data['genres'] as List).map((genreData) {
          return Genre(genreData['id'], genreData['name']);
        }).toList();

        return genres;
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (error) {
      throw Exception('Error fetching genre data: $error');
    }
  }
}