import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:playhaven_mobile/app/playhaven_app.dart';
import 'package:playhaven_mobile/features/catalog/presentation/widgets/home_hero.dart';

final _capture = Platform.environment['PLAYHAVEN_CAPTURE'] == 'true';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    if (!_capture) return;
    const fontRoot = '.tools/flutter/bin/cache/artifacts/material_fonts';
    if (!File('$fontRoot/roboto-regular.ttf').existsSync()) return;
    final loader = FontLoader('Roboto');
    final bytes = await File('$fontRoot/roboto-regular.ttf').readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    final iconFamily = Icons.search.fontPackage == null
        ? Icons.search.fontFamily!
        : 'packages/${Icons.search.fontPackage}/${Icons.search.fontFamily}';
    final icons = FontLoader(iconFamily);
    icons.addFont(
      Future.value(
        ByteData.sublistView(
          await File('$fontRoot/materialicons-regular.otf').readAsBytes(),
        ),
      ),
    );
    await icons.load();
  });

  testWidgets('home adapts to phone/tablet widths and large text', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    for (final (width, scale) in [
      (320.0, 1.0),
      (360.0, 1.0),
      (393.0, 1.0),
      (430.0, 1.0),
      (768.0, 1.0),
      (320.0, 1.8),
    ]) {
      tester.view.physicalSize = Size(width, 852);
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: Size(width, 852),
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            textScaler: TextScaler.linear(scale),
          ),
          child: ProviderScope(
            key: ValueKey('$width-$scale'),
            child: const PlayHavenApp(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomeHero), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Initial home at $width px, text scale $scale',
      );
      await _scrollTo(tester, find.text('Popular games this week'));
      expect(find.text('Popular games this week'), findsOneWidget);
      await _scrollTo(
        tester,
        find.byKey(const ValueKey('home-experiences-heading')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Give every game a place.'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Feature cards at $width px, text scale $scale',
      );
      await _scrollTo(tester, find.text('See the bigger picture.'));
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Last feature at $width px, text scale $scale',
      );
    }
  });

  testWidgets('feature actions open library and explain upcoming features', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PlayHavenApp()));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Build your library'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Build your library'));
    await tester.pumpAndSettle();
    expect(find.text('Koleksi saya'), findsOneWidget);
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Keep a gaming diary'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep a gaming diary'));
    await tester.pumpAndSettle();
    expect(
      find.text('Fitur ini akan hadir di PlayHaven Mobile.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  if (_capture) {
    testWidgets('capture mobile home and feature previews', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(393, 852),
            padding: EdgeInsets.only(top: 24, bottom: 24),
          ),
          child: RepaintBoundary(
            key: boundaryKey,
            child: const ProviderScope(child: PlayHavenApp()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final context = tester.element(find.byType(HomeHero));
        await precacheImage(
          ResizeImage(
            const AssetImage('assets/images/games/a-space-for-the-unbound.jpg'),
            width: 1366,
          ),
          context,
        );
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();
      await _savePreview(tester, boundaryKey, 'home-393');
      await _scrollTo(
        tester,
        find.byKey(const ValueKey('home-experiences-heading')),
      );
      await tester.pumpAndSettle();
      await _savePreview(tester, boundaryKey, 'home-features-393');
    });
  }
}

Future<void> _savePreview(
  WidgetTester tester,
  GlobalKey key,
  String name,
) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('.tools/previews/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  final scrollable = find
      .descendant(
        of: find.byKey(const PageStorageKey('home-scroll')),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.scrollUntilVisible(
    target,
    240,
    scrollable: scrollable,
    maxScrolls: 35,
  );
  await tester.pumpAndSettle();
}
