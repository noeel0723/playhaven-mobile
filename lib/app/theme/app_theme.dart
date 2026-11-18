import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static const background = Color(0xFF010101);
  static const paper = Color(0xFFF4F1ED);
  static const cream = Color(0xFFE7DFD6);
  static const muted = Color(0xFFBDB6B1);
  static const border = Color(0xFF2C2826);

  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: cream,
          brightness: Brightness.dark,
          surface: const Color(0xFF151312),
        ).copyWith(
          primary: cream,
          onPrimary: const Color(0xFF211D1A),
          onSurface: paper,
          onSurfaceVariant: muted,
          secondary: muted,
          secondaryContainer: const Color(0xFF2C2826),
          onSecondaryContainer: paper,
          outline: const Color(0xFF4E4949),
        );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: paper,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: cream,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF181615),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: cream,
        height: 70,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected) ? background : muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
            color: states.contains(WidgetState.selected) ? paper : muted,
          ),
        ),
      ),
    );
  }
}
