// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prohor/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final client = Client().setEndpoint('https://localhost/v1').setProject('test');
    final account = Account(client);
    await tester.pumpWidget(MyApp(account: account));

    // Verify that the login text is present.
    expect(find.text('Appwrite Login'), findsOneWidget);
  });
}
