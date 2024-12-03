import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/ui/pages/home/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope 로 앱을 감싸서 RiverPod이 ViewModel 관리할 수 있게 선언
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
