import 'package:commander_counter/app.dart';
import 'package:commander_counter/features/auth/data/mock_auth_data_provider.dart';
import 'package:commander_counter/features/history/data/local_match_history_data_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts on Life tab', (tester) async {
    await tester.pumpWidget(
      CommanderCounterApp(
        authDataProvider: MockAuthDataProvider(),
        matchHistoryDataProvider: LocalMatchHistoryDataProvider(),
      ),
    );

    expect(find.text('Life'), findsWidgets);
  });
}
