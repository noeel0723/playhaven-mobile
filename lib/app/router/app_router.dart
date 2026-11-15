import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../features/catalog/presentation/catalog_page.dart';
import '../../features/catalog/presentation/game_detail_page.dart';
import '../../features/community/presentation/community_page.dart';
import '../../features/library/presentation/library_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../shell/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const CatalogPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/games/:id',
        builder: (context, state) =>
            GameDetailPage(gameId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('PlayHaven')),
      body: EmptyState(
        icon: Icons.explore_off_outlined,
        title: 'Halaman tidak ditemukan',
        message: 'Kembali ke beranda untuk menjelajahi game.',
        action: FilledButton(
          onPressed: () => context.go('/'),
          child: const Text('Ke beranda'),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});
