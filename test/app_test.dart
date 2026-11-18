import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playhaven_mobile/app/playhaven_app.dart';
import 'package:playhaven_mobile/app/router/app_router.dart';
import 'package:playhaven_mobile/features/catalog/domain/catalog_repository.dart';
import 'package:playhaven_mobile/features/catalog/domain/game.dart';
import 'package:playhaven_mobile/features/catalog/presentation/catalog_providers.dart';

Future<void> launchApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const ProviderScope(child: PlayHavenApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('pencarian menampilkan hasil dan keadaan kosong', (tester) async {
    await launchApp(tester);
    await tester.tap(find.byTooltip('Cari game'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'RPG');
    await tester.pumpAndSettle();
    expect(find.text('Genshin Impact'), findsOneWidget);
    expect(find.text('A Space for the Unbound'), findsNothing);
    await tester.enterText(find.byType(TextField), 'tidak-ada');
    await tester.pumpAndSettle();
    expect(find.text('Game tidak ditemukan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail dan koleksi berbagi state lintas tab', (tester) async {
    await launchApp(tester);
    final poster = find.byKey(
      const ValueKey('popular-game-preview-a-space-for-the-unbound'),
    );
    await tester.ensureVisible(poster);
    await tester.pumpAndSettle();
    await tester.tap(poster);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tambahkan ke koleksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambahkan ke koleksi'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus dari koleksi'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koleksi'));
    await tester.pumpAndSettle();
    expect(find.text('Koleksi saya'), findsOneWidget);
    expect(find.text('A Space for the Unbound'), findsOneWidget);
    await tester.tap(find.text('A Space for the Unbound'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Hapus dari koleksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus dari koleksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Rumah untuk game favoritmu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab komunitas dan profil dapat dibuka pada layar kecil', (
    tester,
  ) async {
    await launchApp(tester);
    await tester.tap(find.text('Komunitas'));
    await tester.pumpAndSettle();
    expect(find.text('Bermain lebih seru bersama'), findsOneWidget);
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang, pemain!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail ID yang tidak dikenal aman dibuka', (tester) async {
    await launchApp(tester);
    final scope = ProviderScope.containerOf(
      tester.element(find.byType(PlayHavenApp)),
    );
    scope.read(appRouterProvider).go('/games/missing');
    await tester.pumpAndSettle();
    expect(find.text('Game tidak ditemukan'), findsOneWidget);
  });

  testWidgets('katalog dapat dicoba kembali setelah repository gagal', (
    tester,
  ) async {
    final repository = _RetryRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
        child: const PlayHavenApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cari game'));
    await tester.pumpAndSettle();
    expect(find.text('Katalog belum dapat dimuat'), findsOneWidget);
    await tester.ensureVisible(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Retry Game'), findsOneWidget);
  });
}

class _RetryRepository implements CatalogRepository {
  int calls = 0;

  @override
  Future<List<Game>> getGames() async {
    if (calls++ == 0) throw Exception('offline');
    return const [
      Game(
        id: 'retry',
        title: 'Retry Game',
        genre: 'Adventure',
        description: 'Demo',
        platforms: ['PC'],
        coverColor: 0xFF6650A4,
      ),
    ];
  }
}
