import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_theme.dart';

class HomeExperiences extends StatelessWidget {
  const HomeExperiences({super.key});

  static const _experiences = [
    _Experience(
      Icons.bookmarks_outlined,
      'Give every game a place.',
      'Keep your whole collection together, then mark games as playing, completed, paused, or dropped.',
      'Build your library',
      '/library',
    ),
    _Experience(
      Icons.favorite_border,
      'Know what stays with you.',
      'Rate in half stars, write your honest take, and choose four favorites to make your profile your own.',
      'Find your favorites',
      '/discover',
    ),
    _Experience(
      Icons.auto_stories_outlined,
      'Remember every chapter.',
      'Log sessions in your diary, track a first playthrough or a replay, and keep the little moments.',
      'Keep a gaming diary',
      null,
    ),
    _Experience(
      Icons.format_list_numbered,
      'Curate a little universe.',
      'Collect comfort games, unforgettable stories, or your next adventures in lists that are yours to share.',
      'Explore game lists',
      null,
    ),
    _Experience(
      Icons.people_outline,
      'Find your kind of players.',
      'Discover public reviews, follow a perspective you love, and see what your circle has to say.',
      'Meet the community',
      '/community',
    ),
    _Experience(
      Icons.bar_chart_outlined,
      'See the bigger picture.',
      'Your ratings, genres, platforms, and the time you have logged. Personal insights, kept just for you.',
      'Explore your statistics',
      null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppTheme.border),
          const SizedBox(height: 26),
          Semantics(
            key: const ValueKey('home-experiences-heading'),
            header: true,
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'A life in games.\n',
                    style: TextStyle(color: AppTheme.paper),
                  ),
                  TextSpan(
                    text: 'A place to keep it.',
                    style: TextStyle(color: AppTheme.muted),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 28,
                height: 1.2,
                letterSpacing: -0.7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns =
                  constraints.maxWidth >= 600 &&
                  MediaQuery.textScalerOf(context).scale(14) < 22;
              final width = twoColumns
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final item in _experiences)
                    SizedBox(
                      width: width,
                      child: _ExperienceCard(item: item),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const Divider(height: 1, color: AppTheme.border),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(
                'YOUR GAMES. YOUR STORIES.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.8,
                  color: Color(0xFF8F8781),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Experience {
  const _Experience(
    this.icon,
    this.title,
    this.description,
    this.action,
    this.route,
  );
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final String? route;
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item});
  final _Experience item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF121110),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final route = item.route;
          if (route == null) {
            _showComingSoon(context);
          } else if (route == '/discover') {
            context.push(route);
          } else {
            context.go(route);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Icon(item.icon, size: 20, color: AppTheme.muted),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE0D9D3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.65,
                  color: Color(0xFFA9A19B),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.action,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFFC5BFBA),
                      ),
                    ),
                  ),
                  if (item.route == null) ...[
                    const SizedBox(width: 8),
                    const Text(
                      'Soon',
                      style: TextStyle(fontSize: 10, color: Color(0xFF8F8781)),
                    ),
                  ],
                  const SizedBox(width: 6),
                  const Icon(Icons.north_east, size: 14, color: AppTheme.muted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, size: 32, color: AppTheme.cream),
            const SizedBox(height: 20),
            Text(
              item.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppTheme.muted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur ini akan hadir di PlayHaven Mobile.',
              style: TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      ),
    );
  }
}
