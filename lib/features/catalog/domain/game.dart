class Game {
  const Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.platforms,
    required this.coverColor,
  });

  final String id;
  final String title;
  final String genre;
  final String description;
  final List<String> platforms;
  final int coverColor;
}
