import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_book_search_app/ui/pages/home/widgets/home_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. ConsumerStatefulWidget으로 변경
class HomePage extends ConsumerStatefulWidget {
  // 3. createState 의 반환타입 변경
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

// 1. ConsumerState로 변경
class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  void search(String text) {
    // 8. 검색 시 뷰모델의 search함수 호출
    ref.read(homeViewModelProvider.notifier).search(text);
    print("search");
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. HomeViewModel 의 상태 구독 시작!
    HomeState homeState = ref.watch(homeViewModelProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            maxLines: 1,
            controller: textEditingController,
            onSubmitted: search,
            decoration: InputDecoration(
              hintText: '검색어를 입력해 주세요',
              border: MaterialStateOutlineInputBorder.resolveWith(
                (states) {
                  if (states.contains(WidgetState.focused)) {
                    return OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    );
                  }
                  return OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                search(textEditingController.text);
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
                child: Icon(Icons.search),
              ),
            ),
          ],
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(20),
          // 5. homeState의 Book List 가 널이면 그리드뷰 아이템은 0개!
          itemCount: homeState.books?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            // 6. book 하나씩 가져오기
            Book book = homeState.books![index];
            return GestureDetector(
              onTap: () {
                print('item tap');
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  builder: (context) {
                    return HomeBottomSheet(book);
                  },
                );
              },
              child: Image.network(
                // 7. 데이터 씌우기
                book.image,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
