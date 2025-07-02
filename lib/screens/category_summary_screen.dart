import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import 'widgets/bottom_navigation.dart';

class CategorySummaryScreen extends StatefulWidget {
  final String category;
  const CategorySummaryScreen({super.key, required this.category});

  @override
  State<CategorySummaryScreen> createState() => _CategorySummaryScreenState();
}

class _CategorySummaryScreenState extends State<CategorySummaryScreen> {
  late List<Transaction> _transactions;
  late double _totalIncome;
  late double _totalExpense;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final box = Hive.box<Transaction>('transactions');
    final all = box.values.where((tx) => tx.category == widget.category).toList();
    all.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _transactions = all;
      _totalIncome = all.where((tx) => tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
      _totalExpense = all.where((tx) => !tx.isIncome).fold(0.0, (sum, tx) => sum + tx.amount);
    });
  }

  List<BarChartGroupData> _buildBarGroups() {
    final grouped = <int, double>{};

    for (var tx in _transactions) {
      final day = tx.date.day;
      grouped[day] = (grouped[day] ?? 0) + tx.amount;
    }

    return grouped.entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(toY: e.value, width: 14, color: Colors.purpleAccent),
        ],
      );
    }).toList();
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.category, style: const TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Statistics'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSummaryCard('-\$${_totalExpense.toStringAsFixed(2)}', 'Витрати', Colors.purpleAccent),
                const SizedBox(width: 12),
                _buildSummaryCard('\$${_totalIncome.toStringAsFixed(2)}', 'Доходи', Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 16),
            _buildBarChart(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  final percent = (_totalExpense + _totalIncome) == 0 ? 0 : (tx.amount / (_totalExpense + _totalIncome) * 100);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('d MMMM yyyy').format(tx.date), style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tx.isIncome ? Colors.green.shade400 : Colors.pink.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.title,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '\$${tx.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    if (tx.tag != null)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text('#${tx.tag}', style: const TextStyle(color: Colors.white70)),
                                      ),
                                  ],
                                ),
                              ),
                              Text('${percent.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String amount, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.image, color: Colors.black),
            const SizedBox(height: 6),
            Text(amount, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
