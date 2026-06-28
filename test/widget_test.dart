import 'package:flutter_test/flutter_test.dart';
import 'package:au_med/app.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AuMedApp());
    await tester.pump();
    expect(find.byType(AuMedApp), findsOneWidget);
  });
}
