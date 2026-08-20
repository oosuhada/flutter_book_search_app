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

  HomeState copyWith({
    List<Book>? books,
    String? query,
    bool? isLoading,
    bool? isSample,
  }) {
    return HomeState(
      books: books ?? this.books,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isSample: isSample ?? this.isSample,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  final BookRepository _repository = BookRepository();

  @override
  HomeState build() {
    return const HomeState(
      books: BookRepository.sampleBooks,
      query: '',
      isLoading: false,
      isSample: true,
    );
  }

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    state = state.copyWith(query: normalizedQuery, isLoading: true);

    // Keeps the transition legible instead of flashing instantly in sample mode.
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final result = await _repository.search(normalizedQuery);

    state = HomeState(
      books: result.books,
      query: normalizedQuery,
      isLoading: false,
      isSample: result.isSample,
    );
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
