import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../domain/game.dart';
import 'game_artwork.dart';

class GameTile extends StatelessWidget {
  const GameTile({required this.game, super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ExcludeSemantics(
          child: SizedBox(
            width: 56,
            height: 56,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GameArtwork(game: game, decodeWidth: 180),
            ),
          ),
        ),
        title: Text(game.title, style: theme.textTheme.titleMedium),
        subtitle: Text(game.genre),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/games/${Uri.encodeComponent(game.id)}'),
      ),
    );
  }
}
