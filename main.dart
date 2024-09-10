import 'movie_controller.dart';

void main() async {
  MovieController controller = MovieController();
  await controller.fetchAndNormalizeData();

  controller.movies?.forEach((movie) {
    print(movie);
  });
}