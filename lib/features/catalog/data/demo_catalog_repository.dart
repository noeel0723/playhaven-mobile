import '../domain/catalog_repository.dart';
import '../domain/game.dart';

/// Preview of the public web catalog captured on 2026-11-18.
/// Ordering is a fixture, not a live weekly popularity calculation.
class DemoCatalogRepository implements CatalogRepository {
  static const _previewDescription =
      'Temukan petualangan berikutnya dan simpan game ini dalam koleksimu. Ini adalah pratinjau katalog PlayHaven web.';

  @override
  Future<List<Game>> getGames() async => const [
    Game(
      id: 'preview-a-space-for-the-unbound',
      title: 'A Space for the Unbound',
      genre: 'Adventure',
      description: _previewDescription,
      platforms: ['PC', 'Nintendo Switch'],
      coverColor: 0xFF51466E,
      coverAsset: 'assets/images/games/a-space-for-the-unbound.jpg',
    ),
    Game(
      id: 'preview-the-walking-dead',
      title: 'The Walking Dead: Season 1',
      genre: 'Adventure',
      description: _previewDescription,
      platforms: ['PC', 'PlayStation 4', 'Xbox One', 'Android', 'iOS'],
      coverColor: 0xFF79553A,
      coverAsset: 'assets/images/games/the-walking-dead.jpg',
    ),
    Game(
      id: 'preview-genshin-impact',
      title: 'Genshin Impact',
      genre: 'RPG',
      description: _previewDescription,
      platforms: ['PC', 'PlayStation 5', 'Android', 'iOS'],
      coverColor: 0xFF467381,
      coverAsset: 'assets/images/games/genshin-impact.jpg',
    ),
    Game(
      id: 'preview-red-dead-redemption-2',
      title: 'Red Dead Redemption 2',
      genre: 'Action',
      description: _previewDescription,
      platforms: ['PC', 'PlayStation 4', 'Xbox One'],
      coverColor: 0xFF9B332D,
      coverAsset: 'assets/images/games/red-dead-redemption-2.jpg',
    ),
    Game(
      id: 'preview-grand-theft-auto-san-andreas',
      title: 'Grand Theft Auto: San Andreas',
      genre: 'Action',
      description: _previewDescription,
      platforms: ['PC', 'PlayStation 4', 'Xbox One', 'Android', 'iOS'],
      coverColor: 0xFF806C43,
      coverAsset: 'assets/images/games/grand-theft-auto-san-andreas.jpg',
    ),
    Game(
      id: 'preview-the-last-of-us',
      title: 'The Last Of Us',
      genre: 'Adventure',
      description: _previewDescription,
      platforms: ['PlayStation 3', 'PlayStation 4'],
      coverColor: 0xFF666C42,
      coverAsset: 'assets/images/games/the-last-of-us.jpg',
    ),
  ];
}
