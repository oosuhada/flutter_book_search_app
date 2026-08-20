import 'package:flutter_book_search_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows reproducible sample book results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Book Finder'), findsOneWidget);
    expect(find.text('Preview data'), findsOneWidget);
    expect(find.text('Find your next read'), findsOneWidget);
    expect(find.text('Flutter in Action'), findsWidgets);
    expect(find.text('Clean Architecture'), findsWidgets);
  });
}
