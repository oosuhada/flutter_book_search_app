import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/ui/pages/home/home_page.dart';
import 'package:flutter_book_search_app/v2/v2_glass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF5B5BD6);
    final baseTheme = V2GlassTheme.light(
      seed: seed,
      background: const Color(0xFFFAF9FD),
      ink: const Color(0xFF2F2C36),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Finder',
      theme: baseTheme.copyWith(
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE8E6EF)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE6E3EC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE6E3EC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: seed, width: 1.5),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
