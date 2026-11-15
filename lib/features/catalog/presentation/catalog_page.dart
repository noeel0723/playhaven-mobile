import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import 'catalog_providers.dart';
import 'widgets/game_tile.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final games = ref.watch(gamesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayHaven'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(label: Text('Demo')),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future).then((_) {}),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petualanganmu\nberikutnya dimulai di sini.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Temukan game. Susun koleksi. Temui teman bermain.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        onChanged: (value) =>
                            setState(() => _query = value.trim().toLowerCase()),
                        decoration: const InputDecoration(
                          hintText: 'Cari judul atau genre game',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text('Jelajahi game', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Katalog contoh untuk mencoba PlayHaven.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              games.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.wifi_off,
                    title: 'Katalog belum dapat dimuat',
                    message: 'Silakan coba memuat kembali.',
                    action: FilledButton(
                      onPressed: () => ref.invalidate(gamesProvider),
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ),
                data: (items) {
                  final filtered = items
                      .where(
                        (game) =>
                            game.title.toLowerCase().contains(_query) ||
                            game.genre.toLowerCase().contains(_query),
                      )
                      .toList();
                  if (filtered.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: 'Game tidak ditemukan',
                        message: 'Coba kata kunci judul atau genre lain.',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          GameTile(game: filtered[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
