import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trimly/core/widgets/trimly_logo.dart';
import 'package:trimly/main.dart';

void main() {
  testWidgets('app boots and shows the Trimly mark', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TrimlyApp()));
    await tester.pump();

    expect(find.byType(TrimlyLogo), findsOneWidget);
  });
}
