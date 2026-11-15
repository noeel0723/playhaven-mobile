import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../catalog/presentation/catalog_providers.dart';
import '../../catalog/presentation/widgets/game_tile.dart';
import 'library_controller.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(libraryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Koleksi saya')),
      body: SafeArea(
        top: false,
        child: ref
            .watch(gamesProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => EmptyState(
                icon: Icons.wifi_off,
                title: 'Koleksi belum dapat dimuat',
                message: 'Silakan coba kembali.',
                action: FilledButton(
                  onPressed: () => ref.invalidate(gamesProvider),
                  child: const Text('Coba lagi'),
                ),
              ),
              data: (games) {
                final collection = games
                    .where((game) => saved.contains(game.id))
                    .toList();
                if (collection.isEmpty) {
                  return EmptyState(
                    icon: Icons.bookmarks_outlined,
                    title: 'Rumah untuk game favoritmu',
                    message: 'Tambahkan game dari beranda untuk mulai menyusun koleksi demo.',
                    action: FilledButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Jelajahi game'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: collection.length,
                  itemBuilder: (context, index) =>
                      GameTile(game: collection[index]),
                );
              },
            ),
      ),
    );
  }
}
