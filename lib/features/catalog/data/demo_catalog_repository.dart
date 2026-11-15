import '../domain/catalog_repository.dart';
import '../domain/game.dart';

/// Data fiktif untuk pengembangan. Tidak berasal dari akun atau katalog live.
class DemoCatalogRepository implements CatalogRepository {
  @override
  Future<List<Game>> getGames() async => const [
    Game(
      id: 'demo-orbit',
      title: 'Orbit Wanderer',
      genre: 'Adventure',
      description: 'Jelajahi planet asing, temukan cerita baru, dan tentukan arah petualanganmu di antara bintang-bintang.',
      platforms: ['PC', 'PlayStation'],
      coverColor: 0xFF6650A4,
    ),
    Game(
      id: 'demo-neon',
      title: 'Neon Circuit',
      genre: 'Racing',
      description: 'Kuasai lintasan kota penuh cahaya dan temukan ritme balapanmu sendiri.',
      platforms: ['PC', 'Xbox'],
      coverColor: 0xFF146C78,
    ),
    Game(
      id: 'demo-grove',
      title: 'The Quiet Grove',
      genre: 'Simulation',
      description: 'Bangun rumah kecil, rawat kebun, dan nikmati cerita sederhana di desa yang hangat.',
      platforms: ['PC', 'Nintendo Switch'],
      coverColor: 0xFF526C43,
    ),
  ];
}
