import 'package:flutter/material.dart';
import 'package:flutter_book_search_app/data/model/book.dart';
import 'package:flutter_book_search_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_book_search_app/ui/pages/home/widgets/home_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController textEditingController =
      TextEditingController(text: 'Flutter');

  Future<void> search(String text) async {
    FocusScope.of(context).unfocus();
    await ref.read(homeViewModelProvider.notifier).search(text);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Finder'),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Find your next read',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '책 제목·저자를 검색하고 결과를 카드로 탐색합니다.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: TextField(
                  maxLines: 1,
                  controller: textEditingController,
                  onSubmitted: search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: '책 제목이나 저자를 검색하세요',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      tooltip: '검색',
                      onPressed: () => search(textEditingController.text),
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '“${state.query}” · ${state.books.length} books',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    if (state.isSample)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Preview data',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (state.isLoading) const LinearProgressIndicator(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  itemCount: state.books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.66,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    return _BookCard(
                      book: book,
                      index: index,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          showDragHandle: true,
                          builder: (context) => HomeBottomSheet(book),
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

class _BookCard extends StatelessWidget {
  const _BookCard({
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
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _BookCover(book: book, index: index),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.publisher,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
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
    if (book.image.isNotEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(12),
        child: Image.network(
          book.image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final palette = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.blueGrey,
      Colors.deepPurple,
      Colors.green,
    ];
    final color = palette[index % palette.length];

    return Container(
      padding: const EdgeInsets.all(18),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 42),
          const SizedBox(height: 14),
          Text(
            book.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
