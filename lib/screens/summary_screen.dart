import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import 'widgets/bottom_navigation.dart';
import 'category_detail_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _showIncome = false;
  String _selectedPeriod = 'Week';
  List<Transaction> _allTransactions = [];
  double _total = 0;
  double _incomeTotal = 0;
  double _expenseTotal = 0;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  final List<String> periods = ['Day', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final box = Hive.box<Transaction>('transactions');
    final now = DateTime.now();
    final startDate = _customStartDate ?? _getStartDate(now);
    final endDate = _customEndDate ?? _getEndDate(now);

    final all = box.values.toList();

    final filtered = all.where((t) {
      return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final totalAmount = filtered.fold(0.0, (sum, t) => sum + t.amount);
    final incomeAmount = filtered.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
    final expenseAmount = filtered.where((t) => !t.isIncome).fold(0.0, (sum, t) => sum + t.amount);

    final viewFiltered = filtered.where((t) => t.isIncome == _showIncome).toList();

    setState(() {
      _allTransactions = viewFiltered;
      _total = totalAmount;
      _incomeTotal = incomeAmount;
      _expenseTotal = expenseAmount;
    });
  }

  DateTime _getStartDate(DateTime now) {
    switch (_selectedPeriod) {
      case 'Day':
        return DateTime(now.year, now.month, now.day);
      case 'Week':
        return now.subtract(Duration(days: now.weekday - 1));
      case 'Month':
        return DateTime(now.year, now.month);
      case 'Year':
        return DateTime(now.year);
      default:
        return now;
    }
  }

  DateTime _getEndDate(DateTime now) {
    switch (_selectedPeriod) {
      case 'Day':
        return DateTime(now.year, now.month, now.day);
      case 'Week':
        return now.add(Duration(days: 7 - now.weekday));
      case 'Month':
        return DateTime(now.year, now.month + 1, 0);
      case 'Year':
        return DateTime(now.year, 12, 31);
      default:
        return now;
    }
  }

  void _toggleType(bool income) {
    setState(() {
      _showIncome = income;
    });
    _loadTransactions();
  }

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
      _customStartDate = null;
      _customEndDate = null;
    });
    _loadTransactions();
  }

  List<Widget> _buildCategoryCards() {
    if (_allTransactions.isEmpty) return [];

    final Map<String, double> categorySums = {};
    final Map<String, Transaction> firstTxMap = {};

    for (var tx in _allTransactions) {
      categorySums[tx.category] = (categorySums[tx.category] ?? 0) + tx.amount;
      firstTxMap[tx.category] ??= tx;
    }

    return categorySums.entries.map((entry) {
      final percent = _total == 0 ? 0 : (entry.value / _total * 100).round();
      final firstTx = firstTxMap[entry.key]!;

      return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryDetailScreen(transaction: firstTx),
            ),
          );
          _loadTransactions();
        },
        child: Container(
          margin: const EdgeInsets.only(top: 12),
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
                    Text('${entry.key}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('$percent%', style: const TextStyle(color: Colors.white70)),
                    if (firstTx.tag != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '# ${firstTx.tag}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              Text('\$${entry.value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = _customStartDate ?? _getStartDate(now);
    final endDate = _customEndDate ?? _getEndDate(now);
    final formattedRange = '${DateFormat('d MMMM').format(startDate)} - ${DateFormat('d MMMM').format(endDate)}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Фінанси', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.swap_vert, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Статистика'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleType(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: !_showIncome ? Colors.transparent : Colors.grey[900],
                          border: Border.all(color: !_showIncome ? Colors.yellowAccent : Colors.transparent),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Розход', style: TextStyle(color: Colors.white)),
                              if (!_showIncome) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check_circle, size: 16, color: Colors.yellowAccent),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleType(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _showIncome ? Colors.transparent : Colors.grey[900],
                          border: Border.all(color: _showIncome ? Colors.yellowAccent : Colors.transparent),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Доход', style: TextStyle(color: Colors.white)),
                              if (_showIncome) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check_circle, size: 16, color: Colors.yellowAccent),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: periods.map((label) {
                  return GestureDetector(
                    onTap: () => _selectPeriod(label),
                    child: Text(
                      label == 'Day'
                          ? 'День'
                          : label == 'Week'
                          ? 'Тиждень'
                          : label == 'Month'
                          ? 'Місяць'
                          : 'Рік',
                      style: TextStyle(
                        color: label == _selectedPeriod ? Colors.yellowAccent : Colors.white,
                        fontWeight: label == _selectedPeriod ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDateRange: DateTimeRange(
                      start: startDate,
                      end: endDate,
                    ),
                  );
                  if (picked != null) {
                    setState(() {
                      _customStartDate = picked.start;
                      _customEndDate = picked.end;
                    });
                    _loadTransactions();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formattedRange, style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${_showIncome ? _incomeTotal.toStringAsFixed(2) : _expenseTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    if (_total == 0)
                      Text(
                        _showIncome
                            ? 'На цьому тижні доходів не було'
                            : 'На цьому тижні розходів не було',
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '-\$${_expenseTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('${((_expenseTotal / (_incomeTotal + _expenseTotal)) * 100).toStringAsFixed(0)}% Витрати'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${_incomeTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('${((_incomeTotal / (_incomeTotal + _expenseTotal)) * 100).toStringAsFixed(0)}% Доходи'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._buildCategoryCards(),
            ],
          ),
        ),
      ),
    );
  }
}
