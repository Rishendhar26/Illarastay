import 'package:flutter_test/flutter_test.dart';
import 'package:illarastay/main.dart';

void main() {
  testWidgets('shows IllaraStay splash branding', (tester) async {
    await tester.pumpWidget(const IllaraStayApp());
    expect(find.text('IllaraStay'), findsOneWidget);
    expect(find.text('Find a place that feels like home.'), findsOneWidget);
  });
}
