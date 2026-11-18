import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import 'catalog_providers.dart';
import 'widgets/home_experiences.dart';
import 'widgets/home_hero.dart';
import 'widgets/popular_games_section.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppTheme.background,
        systemNavigationBarColor: AppTheme.background,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              try {
                await ref.refresh(gamesProvider.future).then<void>((_) {});
              } catch (_) {
                // The provider exposes the failure through the visible error state.
              }
            },
            child: CustomScrollView(
              key: const PageStorageKey('home-scroll'),
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: HomeHero()),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: games.when(
                        loading: () => const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, stack) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
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
                        data: (items) => PopularGamesSection(games: items),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Center(child: ConstrainedHomeExperiences()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConstrainedHomeExperiences extends StatelessWidget {
  const ConstrainedHomeExperiences({super.key});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 840),
    child: const HomeExperiences(),
  );
}
