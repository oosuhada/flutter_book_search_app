import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/ui/pages/detail/detail_page.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet(this.book, {super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 50,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: book.image.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Colors.indigo,
                        child: Center(
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  book.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
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
                    child: const Text(
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
