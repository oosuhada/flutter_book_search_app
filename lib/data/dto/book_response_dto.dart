// {
//   "lastBuildDate": "Fri, 01 Nov 2024 23:58:48 +0900",
//   "total": 4228,
//   "start": 1,
//   "display": 10,
//   "items": [
//   ]
// }

import 'package:flutter_book_search_app/data/model/book.dart';

class BookResponseDto {
  final String lastBuildDate;
  final int total;
  final int start;
  final int display;
  final List<Book> items;

  BookResponseDto({
    required this.lastBuildDate,
    required this.total,
    required this.start,
    required this.display,
    required this.items,
  });

  BookResponseDto.fromJson(Map<String, dynamic> json)
      : this(
          lastBuildDate: json["lastBuildDate"],
          total: json["total"],
          start: json["start"],
          display: json["display"],
          items: List.from(json["items"]).map((e) => Book.fromJson(e)).toList(),
        );

  Map<String, dynamic> toJson() => {
        "lastBuildDate": lastBuildDate,
        "total": total,
        "start": start,
        "display": display,
        "items": items.map((e) => e.toJson()),
      };
}
