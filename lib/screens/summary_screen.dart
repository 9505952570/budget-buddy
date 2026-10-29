import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final entries = provider.totalsByCategory.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No spending data yet. Add an expense to see totals.'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final entry = entries[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.pie_chart_outline),
                    title: Text(entry.key),
                    trailing: Text('£${entry.value.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}
