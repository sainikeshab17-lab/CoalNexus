import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App Shell Bootstraps Successfully Smoke Test', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CoalNexusApp(),
      ),
    );

    // Verify that our dashboard screen placeholder mounts successfully.
    expect(find.text('CoalNexus Dashboard'), findsOneWidget);
  });
}
