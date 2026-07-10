import 'package:aquaflow/core/shared/widgets/aquaflow_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('AquaFlow app starts at splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AquaFlowApp()));

    expect(find.text('AquaFlow'), findsOneWidget);
    expect(find.text('Water Management System'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
