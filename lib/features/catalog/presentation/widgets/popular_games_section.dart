import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/game.dart';
import 'game_artwork.dart';

class PopularGamesSection extends StatelessWidget {
  const PopularGamesSection({required this.games, super.key});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final posterWidth = (constraints.maxWidth * 0.34).clamp(110.0, 148.0);
        final titleHeight =
            MediaQuery.textScalerOf(context).scale(13) * 1.4 * 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Divider(height: 1, color: AppTheme.border),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: const Text(
                            'Popular games this week',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => context.push('/discover'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          foregroundColor: AppTheme.muted,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('View all', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (games.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Text(
                  'No games in the catalog yet.',
                  style: TextStyle(color: AppTheme.muted),
                ),
              )
            else
              SizedBox(
                height: posterWidth * 1.5 + 10 + titleHeight + 2,
                child: ListView.separated(
                  key: const PageStorageKey('popular-games-scroll'),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: games.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return SizedBox(
                      width: posterWidth,
                      child: Semantics(
                        button: true,
                        child: InkWell(
                          key: ValueKey('popular-game-${game.id}'),
                          onTap: () => context.push(
                            '/games/${Uri.encodeComponent(game.id)}',
                          ),
                          borderRadius: BorderRadius.circular(7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.border),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: GameArtwork(
                                      game: game,
                                      decodeHeight:
                                          (posterWidth *
                                                  1.5 *
                                                  MediaQuery.devicePixelRatioOf(
                                                    context,
                                                  ))
                                              .round()
                                              .clamp(320, 720),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                game.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Color(0xFFD5CEC7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
