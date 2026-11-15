import 'game.dart';

abstract interface class CatalogRepository {
  Future<List<Game>> getGames();
}
