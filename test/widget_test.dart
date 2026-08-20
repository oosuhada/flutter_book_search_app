import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/main.dart';
import 'package:flutter_book_search_app/ui/pages/detail/detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();
  }

  testWidgets('shows a curated discovery shelf', (tester) async {
    await pumpApp(tester);

    expect(find.text('Book Finder'), findsOneWidget);
    expect(find.text('Curated'), findsOneWidget);
    expect(find.text('Find your next read'), findsOneWidget);
    expect(find.text('오늘의 큐레이션'), findsOneWidget);
    expect(find.text('8권의 책을 찾았어요'), findsOneWidget);
  });

  testWidgets('searches the curated shelf and shows result count',
      (tester) async {
    await pumpApp(tester);

    await tester.enterText(
      find.byKey(const ValueKey('book-search-field')),
      'Design',
    );
    await tester.tap(find.byKey(const ValueKey('book-search-button')));
    await tester.pump();

    expect(find.text('책장을 살펴보는 중이에요'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(find.text('“Design” 검색 결과'), findsOneWidget);
    expect(find.text('3권의 책을 찾았어요'), findsOneWidget);
  });

  testWidgets('shows a useful empty result state', (tester) async {
    await pumpApp(tester);

    await tester.enterText(
      find.byKey(const ValueKey('book-search-field')),
      'NoSuchBook12345',
    );
    await tester.tap(find.byKey(const ValueKey('book-search-button')));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(find.byKey(const ValueKey('empty-results')), findsOneWidget);
    expect(find.text('아직 이 책장은 비어 있어요'), findsOneWidget);
    expect(find.text('추천 책으로 돌아가기'), findsOneWidget);
  });

  testWidgets('renders a product-style book detail page', (tester) async {
    const book = Book(
      title: 'Testable Architecture',
      link: 'https://example.com/book',
      image: '',
      author: 'Sample Author',
      discount: '',
      publisher: 'Sample Press',
      pubdate: '20260820',
      isbn: '9780000000001',
      description: 'A deterministic detail fixture without network images.',
    );

    await tester.pumpWidget(const MaterialApp(home: DetailPage(book)));
    await tester.pump();

    expect(find.text('Book details'), findsOneWidget);
    expect(find.text('ISBN'), findsOneWidget);
    expect(find.text('9780000000001'), findsOneWidget);
    expect(find.byKey(const ValueKey('open-book-link')), findsOneWidget);
  });
}
