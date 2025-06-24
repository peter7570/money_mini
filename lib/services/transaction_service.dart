// lib/services/transaction_service.dart

import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionService {
  final _box = Hive.box('transactions');

  List<Transaction> getAll() {
    return _box.values.map((item) => Transaction.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> add(Transaction tx) async {
    await _box.add(tx.toMap());
  }

  Future<void> edit(int index, Transaction updatedTx) async {
    final key = _box.keyAt(index);
    await _box.put(key, updatedTx.toMap());
  }
}
