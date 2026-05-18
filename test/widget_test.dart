import 'package:flutter_test/flutter_test.dart';

import 'package:parqit_app/main.dart';

void main() {
  testWidgets('Splash screen renders ParqitApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ParqitApp());

    // SplashScreen should be the initial route.
    // PARQIT wordmark should appear on screen.
    expect(find.text('PARQIT'), findsOneWidget);
  });
}
