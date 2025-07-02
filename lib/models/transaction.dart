import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final bool isIncome;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? comment;

  @HiveField(6)
  final String? imagePath;

  @HiveField(7)
  final String? tag;

  Transaction({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
    this.comment,
    this.imagePath,
    this.tag,
  });
}

