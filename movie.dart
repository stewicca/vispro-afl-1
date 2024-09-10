import 'genre.dart';

class Movie {
  String title;
  String overview;
  DateTime releaseDate;
  List<Genre> genre;

  Movie(this.title, this.overview, this.releaseDate, this.genre);

  @override
  String toString() {
    return 'Movie: $title, Release Date: $releaseDate, Genres: ${genre.map((g) => g.name).join(', ')}';
  }
}