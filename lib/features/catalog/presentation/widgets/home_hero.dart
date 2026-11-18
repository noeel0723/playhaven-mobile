import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_theme.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;
    final artHeight = compact ? (width * 0.9).clamp(280.0, 360.0) : 410.0;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: artHeight,
          child: ExcludeSemantics(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/games/a-space-for-the-unbound.jpg',
                  fit: BoxFit.cover,
                  // Keep the central characters in frame on a portrait viewport.
                  alignment: compact
                      ? const Alignment(0.22, 0)
                      : Alignment.center,
                  cacheWidth: compact ? 1366 : 1600,
                  errorBuilder: (context, error, stack) =>
                      const ColoredBox(color: Color(0xFF292035)),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.2, 0.45, 0.76, 1],
                      colors: [
                        Color(0xD9010101),
                        Color(0x16010101),
                        Color(0x38010101),
                        Color(0xE5010101),
                        AppTheme.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/brand/playhaven-logo.svg',
                              width: 32,
                              height: 22,
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text(
                                'PlayHaven',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.1,
                                  color: AppTheme.paper,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF635C58)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'DEMO',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1,
                            color: AppTheme.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: 'Cari game',
                        onPressed: () => context.push('/discover'),
                        icon: const Icon(Icons.search, size: 23),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 105 : 155),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      children: [
                        const Text(
                          'YOUR GAMES. YOUR STORIES.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            color: Color(0xFFE0D9D3),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          header: true,
                          child: Text.rich(
                            const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Track the worlds you play.\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.paper,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Keep the stories they leave.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFD5CEC7),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: compact ? 28 : 36,
                              height: 1.16,
                              letterSpacing: -0.9,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const ConstrainedHomeDescription(),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FilledButton(
                              onPressed: () => context.go('/library'),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Start your story',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/discover'),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Explore games',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.north_east, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.push(
                            '/games/preview-a-space-for-the-unbound',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF9E9690),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            'A Space for the Unbound  /  Mojiken',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ConstrainedHomeDescription extends StatelessWidget {
  const ConstrainedHomeDescription({super.key});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 330),
    child: const Text(
      'A home for the games you love, the ones you want to play, and the people who understand why they matter.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13, height: 1.65, color: Color(0xFFC5BFBA)),
    ),
  );
}
