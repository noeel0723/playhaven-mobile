import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/empty_state.dart';
import 'catalog_providers.dart';
import 'widgets/game_tile.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jelajahi game')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: TextField(
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
                decoration: const InputDecoration(
                  hintText: 'Cari judul atau genre game',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ref
                  .watch(gamesProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => EmptyState(
                      icon: Icons.wifi_off,
                      title: 'Katalog belum dapat dimuat',
                      message: 'Silakan coba memuat kembali.',
                      action: FilledButton(
                        onPressed: () => ref.invalidate(gamesProvider),
                        child: const Text('Coba lagi'),
                      ),
                    ),
                    data: (games) {
                      final filtered = games
                          .where(
                            (game) =>
                                game.title.toLowerCase().contains(_query) ||
                                game.genre.toLowerCase().contains(_query),
                          )
                          .toList();
                      if (filtered.isEmpty) {
                        return const EmptyState(
                          icon: Icons.search_off,
                          title: 'Game tidak ditemukan',
                          message: 'Coba kata kunci judul atau genre lain.',
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            GameTile(game: filtered[index]),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
