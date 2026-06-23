import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_framework/main.dart';
import 'package:flutter_app_framework/features/example/presentation/pages/example_page.dart';

void main() {
  testWidgets('Application smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Application(startPage: ExamplePage()));
    expect(find.text('ExamplePage'), findsOneWidget);
  });
}
