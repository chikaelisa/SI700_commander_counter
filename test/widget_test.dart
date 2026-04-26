import 'package:commander_counter/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts on Life tab', (WidgetTester tester) async {
    await tester.pumpWidget(const CommanderCounterApp());

    expect(find.text('Life'), findsWidgets);
  });
}
