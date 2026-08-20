import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/ui/pages/detail/detail_page.dart';
import 'package:flutter_book_search_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _suggestions = ['Flutter', 'Architecture', 'Data', 'Design'];

  final TextEditingController _controller = TextEditingController();

  Future<void> _search(String text) async {
    FocusScope.of(context).unfocus();
    await ref.read(homeViewModelProvider.notifier).search(text);
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.collapsed(offset: suggestion.length);
    _search(suggestion);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(child: _BrandBar(isSample: state.isSample)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _DiscoveryHero(
                    controller: _controller,
                    onSubmitted: _search,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        final isSelected = state.query.toLowerCase() ==
                            suggestion.toLowerCase();
                        return _SuggestionPill(
                          label: suggestion,
                          selected: isSelected,
                          onTap: () => _selectSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _ResultsHeading(
                  query: state.query,
                  count: state.books.length,
                  isLoading: state.isLoading,
                ),
              ),
              if (state.isLoading)
                const _LoadingGrid()
              else if (state.books.isEmpty)
                SliverToBoxAdapter(
                  child: _EmptyResults(
                    query: state.query,
                    onReset: () {
                      _controller.clear();
                      _search('');
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid.builder(
                    itemCount: state.books.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 348,
                    ),
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return _BookCard(
                        key: ValueKey('book-card-${book.isbn}'),
                        book: book,
                        index: index,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DetailPage(book),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar({required this.isSample});

  final bool isSample;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.auto_stories_rounded, color: colors.onPrimary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Finder',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 1),
                Text(
                  '읽고 싶은 책을 더 빠르게',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF75717D)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color:
                  isSample ? const Color(0xFFF1EEFF) : const Color(0xFFE8F6EE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSample ? Icons.collections_bookmark_rounded : Icons.bolt,
                  size: 14,
                  color: isSample
                      ? const Color(0xFF6456C7)
                      : const Color(0xFF267A4B),
                ),
                const SizedBox(width: 5),
                Text(
                  isSample ? 'Curated' : 'Live',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryHero extends StatelessWidget {
  const _DiscoveryHero({
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x162D285E),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF252548),
                Color(0xFF414077),
                Color(0xFF6E5DDA),
              ],
              stops: [0, 0.58, 1],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                right: -48,
                top: -70,
                child: _GlowOrb(size: 180, color: Color(0x335FD3FF)),
              ),
              const Positioned(
                left: 116,
                bottom: 34,
                child: _GlowOrb(size: 92, color: Color(0x1AFFFFFF)),
              ),
              const Positioned(
                right: 8,
                top: 14,
                child: _BookStackArtwork(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 13,
                            color: Color(0xFFDCD7FF),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'BOOK DISCOVERY',
                            style: TextStyle(
                              color: Color(0xFFE9E6FF),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(
                      width: 225,
                      child: Text(
                        'Find your next read',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.02,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: 238,
                      child: Text(
                        '취향을 넓혀 줄 한 권,\n오늘 가볍게 발견해 보세요.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 12.8,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 58,
                      padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x240F0B2F),
                            blurRadius: 22,
                            offset: Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.search_rounded,
                            size: 21,
                            color: Color(0xFF7D7789),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              key: const ValueKey('book-search-field'),
                              controller: controller,
                              textInputAction: TextInputAction.search,
                              onSubmitted: onSubmitted,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2F2C36),
                              ),
                              decoration: const InputDecoration(
                                hintText: '제목, 저자, 출판사를 검색해요',
                                hintStyle: TextStyle(
                                  color: Color(0xFFAAA5B1),
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Material(
                            color: const Color(0xFF5F55CC),
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              key: const ValueKey('book-search-button'),
                              onTap: () => onSubmitted(controller.text),
                              borderRadius: BorderRadius.circular(14),
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _BookStackArtwork extends StatelessWidget {
  const _BookStackArtwork();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126,
      height: 144,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 6,
            top: 24,
            child: Transform.rotate(
              angle: 0.14,
              child: const _MiniBook(
                width: 67,
                height: 96,
                color: Color(0xFFF5C98D),
                accent: Color(0xFF8B5E34),
                label: 'ESSAYS',
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 18,
            child: Transform.rotate(
              angle: -0.15,
              child: const _MiniBook(
                width: 68,
                height: 100,
                color: Color(0xFFE9E4FF),
                accent: Color(0xFF6152C2),
                label: 'IDEAS',
              ),
            ),
          ),
          Positioned(
            right: 26,
            top: 7,
            child: Transform.rotate(
              angle: 0.025,
              child: const _MiniBook(
                width: 70,
                height: 104,
                color: Color(0xFFFAF9FF),
                accent: Color(0xFF38345E),
                label: 'READ',
              ),
            ),
          ),
          const Positioned(
            right: 1,
            top: 1,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: Color(0xFFF4D690),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBook extends StatelessWidget {
  const _MiniBook({
    required this.width,
    required this.height,
    required this.color,
    required this.accent,
    required this.label,
  });

  final double width;
  final double height;
  final Color color;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(9, 10, 7, 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x300E0C28),
            blurRadius: 13,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            height: 1,
            color: accent.withValues(alpha: 0.22),
          ),
        ],
      ),
    );
  }
}

class _SuggestionPill extends StatelessWidget {
  const _SuggestionPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEEEAFE) : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? const Color(0xFFCFC5FA) : const Color(0xFFE8E4EC),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 13,
                  color: Color(0xFF6258C9),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.2,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF5148B6)
                      : const Color(0xFF6F6977),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsHeading extends StatelessWidget {
  const _ResultsHeading({
    required this.query,
    required this.count,
    required this.isLoading,
  });

  final String query;
  final int count;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  query.isEmpty ? '오늘의 큐레이션' : '“$query” 검색 결과',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isLoading ? '책장을 살펴보는 중이에요' : '$count권의 책을 찾았어요',
                  style: const TextStyle(
                    color: Color(0xFF77727F),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isLoading)
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.grid_view_rounded, size: 18),
            ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    super.key,
    required this.book,
    required this.index,
    required this.onTap,
  });

  final Book book;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 205,
              child: Hero(
                tag: 'book-cover-${book.isbn}-${book.title}',
                child: _BookCover(book: book, index: index),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.3,
                        color: Color(0xFF706C77),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      book.publisher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      book.publicationLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF928D98),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.book, required this.index});

  final Book book;
  final int index;

  @override
  Widget build(BuildContext context) {
    final child = book.image.isEmpty
        ? _placeholder(context)
        : Image.network(
            book.image,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => _placeholder(context),
          );

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F1F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
      ),
      child: child,
    );
  }

  Widget _placeholder(BuildContext context) {
    const palette = [
      Color(0xFF5D5BD4),
      Color(0xFF327A70),
      Color(0xFFB85D4A),
      Color(0xFF48667C),
    ];
    final color = palette[index % palette.length];

    return AspectRatio(
      aspectRatio: 0.68,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              blurRadius: 9,
              offset: Offset(0, 5),
              color: Color(0x26000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded,
                  color: Colors.white, size: 32),
              const SizedBox(height: 10),
              Text(
                book.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      sliver: SliverGrid.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          mainAxisExtent: 348,
        ),
        itemBuilder: (context, index) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    const fill = Color(0xFFECE9F1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 195,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 13,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: .68,
              child: Container(
                height: 11,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query, required this.onReset});

  final String query;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Container(
        key: const ValueKey('empty-results'),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE8E5ED)),
        ),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 28),
            ),
            const SizedBox(height: 16),
            const Text(
              '아직 이 책장은 비어 있어요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              '“$query”와 일치하는 책을 찾지 못했어요.\n다른 제목이나 저자로 다시 검색해 보세요.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1.45,
                fontSize: 13.5,
                color: Color(0xFF77727F),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: onReset,
              icon: const Icon(Icons.auto_stories_rounded, size: 18),
              label: const Text('추천 책으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
