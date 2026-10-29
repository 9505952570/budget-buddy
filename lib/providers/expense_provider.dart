import 'package:flutter/foundation.dart';

import '../models/expense.dart';
import '../services/expense_storage.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider() : _storage = ExpenseStorage();

  final ExpenseStorage _storage;
  List<Expense> _expenses = <Expense>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  double get totalSpend => _expenses.fold<double>(0, (sum, expense) => sum + expense.amount);

  Map<String, double> get totalsByCategory {
    final map = <String, double>{};
    for (final expense in _expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  Future<void> loadExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _expenses = await _storage.loadExpenses();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
    } catch (_) {
      _errorMessage = 'Could not load expenses. Please try again.';
      _expenses = <Expense>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLoad() async {
    await loadExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    await _storage.saveExpenses(_expenses);
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      await _storage.saveExpenses(_expenses);
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    _expenses.removeWhere((expense) => expense.id == expenseId);
    notifyListeners();
    await _storage.saveExpenses(_expenses);
  }
}
