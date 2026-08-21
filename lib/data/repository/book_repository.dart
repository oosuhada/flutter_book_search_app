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

  static const List<Book> sampleBooks = [
    Book(
      title: 'Flutter in Action',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9781617296147-M.jpg',
      author: 'Eric Windmill',
      discount: '',
      publisher: 'Manning',
      pubdate: '20200107',
      isbn: '9781617296147',
      description:
          'Flutter의 위젯, 상태 관리, 애니메이션과 앱 구조를 실제 예제로 익힐 수 있는 실전 입문서입니다.',
    ),
    Book(
      title: 'Clean Architecture',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9780134494166-M.jpg',
      author: 'Robert C. Martin',
      discount: '',
      publisher: 'Prentice Hall',
      pubdate: '20170920',
      isbn: '9780134494166',
      description:
          '변화에 강한 소프트웨어를 만들기 위해 경계, 의존성 규칙, 컴포넌트 설계를 어떻게 다뤄야 하는지 설명합니다.',
    ),
    Book(
      title: 'Designing Data-Intensive Applications',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9781449373320-M.jpg',
      author: 'Martin Kleppmann',
      discount: '',
      publisher: "O'Reilly Media",
      pubdate: '20170316',
      isbn: '9781449373320',
      description:
          '데이터 시스템의 저장, 복제, 분산 처리와 일관성 문제를 폭넓게 다루는 현대 백엔드 설계의 대표 참고서입니다.',
    ),
    Book(
      title: 'The Pragmatic Programmer',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9780135957059-M.jpg',
      author: 'David Thomas · Andrew Hunt',
      discount: '',
      publisher: 'Addison-Wesley',
      pubdate: '20190913',
      isbn: '9780135957059',
      description:
          '코드 작성부터 협업, 자동화, 디버깅까지 오래 써먹을 수 있는 실용적인 개발 습관과 문제 해결 방식을 담았습니다.',
    ),
    Book(
      title: 'Refactoring',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9780134757599-M.jpg',
      author: 'Martin Fowler',
      discount: '',
      publisher: 'Addison-Wesley',
      pubdate: '20181120',
      isbn: '9780134757599',
      description:
          '기존 동작을 보존하면서 코드의 구조를 안전하게 개선하는 리팩터링 기법과 판단 기준을 구체적인 예제로 설명합니다.',
    ),
    Book(
      title: 'Head First Design Patterns',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9781492078005-M.jpg',
      author: 'Eric Freeman · Elisabeth Robson',
      discount: '',
      publisher: "O'Reilly Media",
      pubdate: '20201229',
      isbn: '9781492078005',
      description:
          '객체지향 설계 패턴을 시각적인 설명과 반복 가능한 예제로 풀어내 패턴의 의도와 적용 시점을 익히기 좋은 책입니다.',
    ),
    Book(
      title: "Don't Make Me Think, Revisited",
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9780321965516-M.jpg',
      author: 'Steve Krug',
      discount: '',
      publisher: 'New Riders',
      pubdate: '20140103',
      isbn: '9780321965516',
      description:
          '사용자가 생각하지 않아도 자연스럽게 이해할 수 있는 화면을 만들기 위한 웹·모바일 사용성 원칙을 간결하게 소개합니다.',
    ),
    Book(
      title: 'The Design of Everyday Things',
      link: 'https://search.shopping.naver.com/book/home',
      image: 'https://covers.openlibrary.org/b/isbn/9780465050659-M.jpg',
      author: 'Don Norman',
      discount: '',
      publisher: 'Basic Books',
      pubdate: '20131105',
      isbn: '9780465050659',
      description:
          '좋은 제품이 어떻게 행동을 유도하고 실수를 예방하는지 일상 사물의 사례를 통해 설명하는 디자인 고전입니다.',
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
          {'query': normalizedQuery.isEmpty ? '개발' : normalizedQuery},
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
      // A deterministic curated shelf keeps the portfolio preview usable
      // when the network/API is unavailable without ever bundling credentials.
    } finally {
      client.close();
    }

    return BookSearchResult(
      books: _sampleSearch(normalizedQuery),
      isSample: true,
    );
  }

  List<Book> _sampleSearch(String query) {
    if (query.isEmpty) return List<Book>.unmodifiable(sampleBooks);

    final lower = query.toLowerCase();
    return sampleBooks.where((book) {
      return book.title.toLowerCase().contains(lower) ||
          book.author.toLowerCase().contains(lower) ||
          book.publisher.toLowerCase().contains(lower) ||
          book.description.toLowerCase().contains(lower);
    }).toList(growable: false);
  }
}
