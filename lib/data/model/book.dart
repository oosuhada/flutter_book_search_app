class Book {
  const Book({
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

  final String title;
  final String link;
  final String image;
  final String author;
  final String discount;
  final String publisher;
  final String pubdate;
  final String isbn;
  final String description;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: _cleanText(json['title']),
      link: _cleanText(json['link']),
      image: _cleanText(json['image']),
      author: _cleanText(json['author']),
      discount: _cleanText(json['discount']),
      publisher: _cleanText(json['publisher']),
      pubdate: _cleanText(json['pubdate']),
      isbn: _cleanText(json['isbn']),
      description: _cleanText(json['description']),
    );
  }

  String get publicationLabel {
    if (pubdate.length != 8) return pubdate.isEmpty ? '출간일 미상' : pubdate;
    return '${pubdate.substring(0, 4)}.${pubdate.substring(4, 6)}.${pubdate.substring(6, 8)}';
  }

  String get descriptionOrFallback => description.isEmpty
      ? '책 소개가 아직 제공되지 않았습니다. 상세 페이지에서 더 많은 정보를 확인해 보세요.'
      : description;

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
        'image': image,
        'author': author,
        'discount': discount,
        'publisher': publisher,
        'pubdate': pubdate,
        'isbn': isbn,
        'description': description,
      };
}

String _cleanText(dynamic value) {
  return (value ?? '')
      .toString()
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();
}
