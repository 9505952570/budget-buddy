import 'dart:convert';

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  String get formattedAmount => '£${amount.toStringAsFixed(2)}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Expense',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? 'Other',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      note: json['note'] as String? ?? '',
    );
  }

  static String encodeList(List<Expense> expenses) {
    return jsonEncode(expenses.map((expense) => expense.toJson()).toList());
  }

  static List<Expense> decodeList(String encoded) {
    final decoded = jsonDecode(encoded) as List<dynamic>;
    return decoded
        .map((item) => Expense.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
