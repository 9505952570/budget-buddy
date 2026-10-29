import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class ExpenseStorage {
  static const String _key = 'budget_buddy_expenses';

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_key) ?? <String>[];
    return entries
        .map((entry) => Expense.fromJson(jsonDecode(entry) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final items = expenses.map((expense) => jsonEncode(expense.toJson())).toList();
    await prefs.setStringList(_key, items);
  }
}
