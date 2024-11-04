import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/data/repository/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 화면에서 필요한 상태 만들기!
class HomeState {
  HomeState({required this.books});
  List<Book>? books;
}

// 2. 상태를 관리할 뷰모델 만들기! Notifier<뷰모델이 관리할 상태 클래스>
class HomeViewModel extends Notifier<HomeState> {
  // 3. build 함수 재정의 해서 초기상태 리턴해주기!
  @override
  HomeState build() {
    return HomeState(books: null);
  }

  // 4. Repository에서 데이터 받아와서 상태 업데이트 해주기!
  Future<void> search(String query) async {
    BookRepository bookRepository = BookRepository();
    state = HomeState(
      books: await bookRepository.search(query),
    );
  }
}

// 5. HomeViewModel을 관리할 관리자 만들어주기
// NotifierProvider<HomeViewModel, HomeState>
// => HomeState 상태를 관리하는 HomeViewModel 관리해주세요.
// ref.watch를 통해 homeViewModelProvider를 부르면 아직 생성안됐으면 만들어서 주고, 있으면 있던거 주세요!
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
