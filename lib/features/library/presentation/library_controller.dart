import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Koleksi demo disimpan selama sesi aplikasi, belum disinkronkan ke server.
final libraryProvider = NotifierProvider<LibraryController, Set<String>>(
  LibraryController.new,
);

class LibraryController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String gameId) {
    state = state.contains(gameId)
        ? Set.unmodifiable({...state}..remove(gameId))
        : Set.unmodifiable({...state, gameId});
  }
}
