import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../library/presentation/library_controller.dart';
import 'catalog_providers.dart';
import 'widgets/game_artwork.dart';

class GameDetailPage extends ConsumerWidget {
  const GameDetailPage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(libraryProvider).contains(gameId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail game'),
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: ref
            .watch(gamesProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => EmptyState(
                icon: Icons.wifi_off,
                title: 'Game belum dapat dimuat',
                message: 'Silakan coba kembali.',
                action: FilledButton(
                  onPressed: () => ref.invalidate(gamesProvider),
                  child: const Text('Coba lagi'),
                ),
              ),
              data: (games) {
                final matches = games.where((game) => game.id == gameId);
                if (matches.isEmpty) {
                  return const EmptyState(
                    icon: Icons.videogame_asset_off_outlined,
                    title: 'Game tidak ditemukan',
                    message: 'Pilih game lain dari beranda.',
                  );
                }
                final game = matches.first;
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GameArtwork(game: game, decodeWidth: 1080),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      game.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(game.genre)),
                        for (final platform in game.platforms)
                          Chip(label: Text(platform)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(game.description, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: () =>
                          ref.read(libraryProvider.notifier).toggle(gameId),
                      icon: Icon(
                        saved
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined,
                      ),
                      label: Text(
                        saved ? 'Hapus dari koleksi' : 'Tambahkan ke koleksi',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Koleksi demo tersimpan selama aplikasi terbuka.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }
}
