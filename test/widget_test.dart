import 'package:budget_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app loads empty state and creates expense entry', (tester) async {
    await tester.pumpWidget(const BudgetBuddyApp());
    await tester.pumpAndSettle();

    expect(find.text('No expenses yet'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('titleField')), 'Groceries');
    await tester.enterText(find.byKey(const ValueKey('amountField')), '42.50');
    await tester.tap(find.byKey(const ValueKey('saveExpenseButton')));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('£42.50'), findsWidgets);
  });
}
