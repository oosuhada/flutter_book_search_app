import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/data/repository/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  const HomeState({
    required this.books,
    required this.query,
    required this.isLoading,
    required this.isSample,
  });

  final List<Book> books;
  final String query;
  final bool isLoading;
  final bool isSample;
}

class HomeViewModel extends Notifier<HomeState> {
  final BookRepository _repository = BookRepository();

  @override
  HomeState build() {
    return HomeState(
      books: BookRepository.sampleBooks,
      query: 'Flutter',
      isLoading: false,
      isSample: true,
    );
  }

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    state = HomeState(
      books: state.books,
      query: normalizedQuery,
      isLoading: true,
      isSample: state.isSample,
    );

    final result = await _repository.search(normalizedQuery);
    state = HomeState(
      books: result.books,
      query: normalizedQuery.isEmpty ? 'Flutter' : normalizedQuery,
      isLoading: false,
      isSample: result.isSample,
    );
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
