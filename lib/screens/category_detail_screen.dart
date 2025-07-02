import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import '../models/transaction.dart';
import 'widgets/bottom_navigation.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Transaction transaction;
  const CategoryDetailScreen({super.key, required this.transaction});

  Future<void> _deleteTransaction(BuildContext context) async {
    final box = Hive.box<Transaction>('transactions');
    final key = box.keys.firstWhere(
          (k) => box.get(k) == transaction,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(transaction.category, style: const TextStyle(color: Colors.white)),
        actions: const [Icon(Icons.swap_vert, color: Colors.white), SizedBox(width: 16)],
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Categories'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('d MMMM yyyy').format(transaction.date),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.black),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        if (transaction.tag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '# ${transaction.tag}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (transaction.imagePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(transaction.imagePath!),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Comment:', style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTransaction(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              transaction.comment?.isNotEmpty == true ? transaction.comment! : 'No comment',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
