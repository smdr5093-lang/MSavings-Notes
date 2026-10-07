class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String currency; // "INR" or "USD"
  final String type; // "income" or "expense"
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'currency': currency,
      'type': type,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    return TransactionModel(
      id: docId,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'INR',
      type: map['type'] ?? 'expense',
      date: DateTime.parse(map['date']),
    );
  }
}
