// {
//       "title": "Harry Potter (Welcome to Hogwarts Planner Notebook Collection (Set of 3): (Harry Potter School Planner School, Harry Potter Gift, Harry Potter Station)",
//       "link": "https://search.shopping.naver.com/book/catalog/43805245634",
//       "image": "https://shopping-phinf.pstatic.net/main_4380524/43805245634.20240616071135.jpg",
//       "author": "Insight Editions",
//       "discount": "18500",
//       "publisher": "Insight Editions",
//       "pubdate": "20230606",
//       "isbn": "9798886631418",
//       "description": ""
// }

class Book {
  final String title;
  final String link;
  final String image;
  final String author;
  final String discount;
  final String publisher;
  final String pubdate;
  final String isbn;
  final String description;

  Book({
    required this.title,
    required this.link,
    required this.image,
    required this.author,
    required this.discount,
    required this.publisher,
    required this.pubdate,
    required this.isbn,
    required this.description,
  });

  Book.fromJson(Map<String, dynamic> json)
      : this(
          title: json["title"],
          link: json["link"],
          image: json["image"],
          author: json["author"],
          discount: json["discount"],
          publisher: json["publisher"],
          pubdate: json["pubdate"],
          isbn: json["isbn"],
          description: json["description"],
        );

  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
        "image": image,
        "author": author,
        "discount": discount,
        "publisher": publisher,
        "pubdate": pubdate,
        "isbn": isbn,
        "description": description,
      };
}
