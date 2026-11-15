import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/demo_catalog_repository.dart';
import '../domain/catalog_repository.dart';
import '../domain/game.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return DemoCatalogRepository();
});

final gamesProvider = FutureProvider<List<Game>>(
  (ref) => ref.watch(catalogRepositoryProvider).getGames(),
  // Let the page offer an explicit retry instead of retrying indefinitely.
  retry: (retryCount, error) => null,
);
