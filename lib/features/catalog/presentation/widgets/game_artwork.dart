import 'package:material_ui/material_ui.dart';

import '../../domain/game.dart';

/// Decode posters near their displayed size rather than retaining a full 4K image.
class GameArtwork extends StatelessWidget {
  const GameArtwork({
    required this.game,
    this.fit = BoxFit.cover,
    this.alignment = const Alignment(0.2, 0),
    this.decodeWidth = 480,
    this.decodeHeight,
    super.key,
  });

  final Game game;
  final BoxFit fit;
  final Alignment alignment;
  final int decodeWidth;
  final int? decodeHeight;

  @override
  Widget build(BuildContext context) {
    final asset = game.coverAsset;
    if (asset == null) return _fallback();
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
      cacheWidth: decodeHeight == null ? decodeWidth : null,
      cacheHeight: decodeHeight,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stack) => _fallback(),
    );
  }

  Widget _fallback() => ColoredBox(
    color: Color(game.coverColor),
    child: const Center(
      child: Icon(Icons.sports_esports_outlined, color: Colors.white, size: 34),
    ),
  );
}
