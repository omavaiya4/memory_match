import 'package:flutter_test/flutter_test.dart';
import 'package:memory_match/main.dart';

void main() {
  testWidgets('Home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryMatchApp());
    expect(find.text('Memory Match'), findsOneWidget);
    expect(find.text('Easy  (4 × 3)'), findsOneWidget);
  });
}
