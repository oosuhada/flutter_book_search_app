import 'dart:convert';

import 'package:flutter_book_search_app/data/dto/book_response_dto.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:http/http.dart';

class BookSearchResult {
  const BookSearchResult({required this.books, required this.isSample});

  final List<Book> books;
  final bool isSample;
}

class BookRepository {
  static const String _clientId = String.fromEnvironment('NAVER_CLIENT_ID');
  static const String _clientSecret =
      String.fromEnvironment('NAVER_CLIENT_SECRET');

  static bool get hasLiveCredentials =>
      _clientId.isNotEmpty && _clientSecret.isNotEmpty;

  static final List<Book> sampleBooks = [
    Book(
      title: 'Flutter in Action',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'Eric Windmill',
      discount: '',
      publisher: 'Manning',
      pubdate: '20200107',
      isbn: '9781617296147',
      description: 'Flutter의 widget, state, animation을 단계별로 다루는 sample book.',
    ),
    Book(
      title: 'Clean Architecture',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'Robert C. Martin',
      discount: '',
      publisher: 'Prentice Hall',
      pubdate: '20170920',
      isbn: '9780134494166',
      description: '유지보수 가능한 소프트웨어 구조와 경계 설계를 다루는 책.',
    ),
    Book(
      title: 'Designing Data-Intensive Applications',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'Martin Kleppmann',
      discount: '',
      publisher: "O'Reilly Media",
      pubdate: '20170316',
      isbn: '9781449373320',
      description: '데이터 시스템의 저장, 복제, 분산 처리 원리를 설명하는 책.',
    ),
    Book(
      title: 'The Pragmatic Programmer',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'David Thomas · Andrew Hunt',
      discount: '',
      publisher: 'Addison-Wesley',
      pubdate: '20190913',
      isbn: '9780135957059',
      description: '실용적인 개발 습관과 문제 해결 방식을 다루는 개발 고전.',
    ),
    Book(
      title: 'Refactoring',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'Martin Fowler',
      discount: '',
      publisher: 'Addison-Wesley',
      pubdate: '20181120',
      isbn: '9780134757599',
      description: '동작을 보존하면서 코드 구조를 개선하는 리팩터링 패턴 모음.',
    ),
    Book(
      title: 'Learning Riverpod',
      link: 'https://search.shopping.naver.com/book/home',
      image: '',
      author: 'Portfolio sample',
      discount: '',
      publisher: 'Sample data',
      pubdate: '20260820',
      isbn: 'SAMPLE-RIVERPOD',
      description: '검색·상태관리 UI를 안정적으로 보여주기 위한 portfolio sample item.',
    ),
  ];

  Future<BookSearchResult> search(String query) async {
    final normalizedQuery = query.trim();

    if (!hasLiveCredentials) {
      return BookSearchResult(
        books: _sampleSearch(normalizedQuery),
        isSample: true,
      );
    }

    final client = Client();
    try {
      final result = await client.get(
        Uri.https(
          'openapi.naver.com',
          '/v1/search/book.json',
          {'query': normalizedQuery.isEmpty ? 'Flutter' : normalizedQuery},
        ),
        headers: {
          'X-Naver-Client-Id': _clientId,
          'X-Naver-Client-Secret': _clientSecret,
        },
      );

      if (result.statusCode == 200) {
        final dto = BookResponseDto.fromJson(jsonDecode(result.body));
        return BookSearchResult(books: dto.items, isSample: false);
      }
    } catch (_) {
      // Fall back to deterministic sample data for an offline portfolio preview.
    } finally {
      client.close();
    }

    return BookSearchResult(
      books: _sampleSearch(normalizedQuery),
      isSample: true,
    );
  }

  List<Book> _sampleSearch(String query) {
    if (query.isEmpty || query.toLowerCase() == 'flutter') {
      return List<Book>.unmodifiable(sampleBooks);
    }

    final lower = query.toLowerCase();
    final matches = sampleBooks.where((book) {
      return book.title.toLowerCase().contains(lower) ||
          book.author.toLowerCase().contains(lower) ||
          book.publisher.toLowerCase().contains(lower);
    }).toList();

    return matches.isEmpty ? List<Book>.unmodifiable(sampleBooks) : matches;
  }
}
