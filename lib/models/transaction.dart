// lib/models/transaction.dart

class Transaction {
  final String title;
  final double amount;
  final bool isIncome;
  final String category;

  Transaction({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'amount': amount,
        'isIncome': isIncome,
        'category': category,
      };

  static Transaction fromMap(Map<dynamic, dynamic> map) => Transaction(
        title: map['title'],
        amount: map['amount'],
        isIncome: map['isIncome'],
        category: map['category'],
      );
}
