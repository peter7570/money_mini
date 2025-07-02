import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionService {
  final Box<Transaction> _box = Hive.box<Transaction>('transactions');

  List<Transaction> getAll() {
    return _box.values.cast<Transaction>().toList();
  }

  Future<void> add(Transaction tx) async {
    await _box.add(tx);
  }

  Future<void> edit(int index, Transaction updatedTx) async {
    final key = _box.keyAt(index);
    await _box.put(key, updatedTx);
  }
}
