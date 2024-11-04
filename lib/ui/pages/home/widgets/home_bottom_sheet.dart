import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/ui/pages/detail/detail_page.dart';

class HomeBottomSheet extends StatelessWidget {
  // 2. 생성자에 추가
  HomeBottomSheet(this.book);

  // 1. 홈페이지에서 전달해줄 수 있게 추가
  Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 50,
      ),
      child: Row(
        children: [
          // 3. 데이터 씌우기
          Image.network(
            book.image,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  book.description,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // 자세히 보기 터치했을 때 DetailPage로 가게 미리 구현
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return DetailPage(book);
                      },
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50, // UX 고려한 높이
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Text(
                      '자세히 보기',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
