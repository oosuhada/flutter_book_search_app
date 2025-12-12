import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/v2/v2_glass.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.book, {super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          AppGlassToolbar(
            title: 'Book details',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  sliver: SliverList.list(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 26),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEF6),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 164,
                            height: 238,
                            child: Hero(
                              tag: 'book-cover-${book.isbn}-${book.title}',
                              child: _DetailCover(book: book),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppGlassSurface(
                        tint: const Color(0xFFF7F5FC),
                        surfaceOpacity: .76,
                        blurSigma: 20,
                        borderRadius: BorderRadius.circular(26),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 26,
                                height: 1.17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.6,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              book.author.isEmpty ? '저자 정보 없음' : book.author,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _MetadataPanel(book: book),
                            const SizedBox(height: 24),
                            const Text(
                              '책 소개',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book.descriptionOrFallback,
                              style: const TextStyle(
                                color: Color(0xFF4F4A57),
                                fontSize: 14.5,
                                height: 1.65,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 108),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppGlassBottomBar(
        child: Row(
          children: [
            SizedBox(
              width: 54,
              height: 52,
              child: IconButton.outlined(
                tooltip: '관심 목록에 담기',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('“${book.title}”을 관심 목록에 담았어요.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add_outlined),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: FilledButton.icon(
                  key: const ValueKey('open-book-link'),
                  onPressed: book.link.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => BookWebPage(book: book),
                            ),
                          );
                        },
                  icon: const Icon(Icons.open_in_new_rounded, size: 19),
                  label: const Text(
                    '온라인 상세 보기',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataPanel extends StatelessWidget {
  const _MetadataPanel({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return AppGlassSurface(
      borderRadius: BorderRadius.circular(20),
      blurSigma: 16,
      surfaceOpacity: .66,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          _MetadataRow(
            icon: Icons.apartment_rounded,
            label: '출판사',
            value: book.publisher.isEmpty ? '정보 없음' : book.publisher,
          ),
          const Divider(height: 1),
          _MetadataRow(
            icon: Icons.calendar_month_rounded,
            label: '출간일',
            value: book.publicationLabel,
          ),
          const Divider(height: 1),
          _MetadataRow(
            icon: Icons.qr_code_2_rounded,
            label: 'ISBN',
            value: book.isbn.isEmpty ? '정보 없음' : book.isbn,
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF85808C),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCover extends StatelessWidget {
  const _DetailCover({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories_rounded,
                color: Colors.white, size: 38),
            const SizedBox(height: 14),
            Text(
              book.title,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x32000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: book.image.isEmpty
            ? placeholder
            : ColoredBox(
                color: Colors.white,
                child: Image.network(
                  book.image,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : placeholder,
                  errorBuilder: (_, __, ___) => placeholder,
                ),
              ),
      ),
    );
  }
}

class BookWebPage extends StatelessWidget {
  const BookWebPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: true,
        ),
        initialUrlRequest: URLRequest(url: WebUri(book.link)),
      ),
    );
  }
}
