import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/category_grid.dart';
import 'widgets/bottom_navigation.dart';
import '../services/transaction_service.dart';
import 'add_transaction_screen.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showIncome = false;
  String activePeriod = 'Week';
  DateTime startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime endDate = DateTime.now();
  double totalAmount = 0.0;
  List<Transaction> transactions = [];

  final List<Map<String, dynamic>> categories = [
    {'label': 'Health', 'iconPath': 'assets/icons/health.png', 'color': const Color(0xFFFF8A80)},
    {'label': 'Home', 'iconPath': 'assets/icons/home.png', 'color': const Color(0xFFB39DDB)},
    {'label': 'Expenses', 'iconPath': 'assets/icons/expenses.png', 'color': const Color(0xFFD7CCC8)},
    {'label': 'Cafe', 'iconPath': 'assets/icons/cafe.png', 'color': const Color(0xFFDCEDC8)},
    {'label': 'Education', 'iconPath': 'assets/icons/education.png', 'color': const Color(0xFF80DEEA)},
    {'label': 'Products', 'iconPath': 'assets/icons/products.png', 'color': const Color(0xFFFFCC80)},
    {'label': 'Gifts', 'iconPath': 'assets/icons/gifts.png', 'color': const Color(0xFFE1BEE7)},
    {'label': 'Transport', 'iconPath': 'assets/icons/transport.png', 'color': const Color(0xFF90CAF9)},
    {'label': 'Travel', 'iconPath': 'assets/icons/travel.png', 'color': const Color(0xFF80DEEA)},
    {'label': 'Sports', 'iconPath': 'assets/icons/sports.png', 'color': const Color(0xFFFFAB91)},
    {'label': 'Pets', 'iconPath': 'assets/icons/pets.png', 'color': const Color(0xFFCE93D8)},
    {'label': 'Car', 'iconPath': 'assets/icons/car.png', 'color': const Color(0xFF81D4FA)},
  ];

  @override
  void initState() {
    super.initState();
    _updateDateRange();
    _loadTransactions();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (activePeriod) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate;
        break;
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = now.add(Duration(days: 7 - now.weekday));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      default:
        startDate = DateTime.now().subtract(const Duration(days: 6));
        endDate = DateTime.now();
    }
  }

  Future<void> _loadTransactions() async {
    final List<Transaction> allTransactions = TransactionService().getAll();
    print("All Transactions Loaded (${allTransactions.length}):");
    for (var t in allTransactions) {
      print("${t.amount} | ${t.isIncome} | ${t.date}");
    }
    final filtered = allTransactions.where((t) {
      return t.isIncome == showIncome &&
          t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    setState(() {
      transactions = filtered;
      totalAmount = filtered.fold(0.0, (sum, t) => sum + t.amount);
    });
  }

  void _toggleIncome(bool income) {
    setState(() {
      showIncome = income;
    });
    _loadTransactions();
  }

  Widget buildCategoryItem(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              category: category,
              isIncome: showIncome,
            ),
          ),
        );
        _loadTransactions();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              category['iconPath'],
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category['label'],
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildCircleWithSum(double amount) {
    return Container(
      width: 154,
      height: 154,
      padding: const EdgeInsets.symmetric(horizontal: 23),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFB9D7FF), width: 8),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          '\$${amount.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFFA5C3FF),
            height: 1.2,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final periodText =
        '${DateFormat('d MMMM').format(startDate)} - ${DateFormat('d MMMM').format(endDate)}';

    final List<Transaction> allTransactions = TransactionService().getAll();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const Icon(Icons.grid_view, color: Colors.white),
        actions: const [Icon(Icons.swap_vert, color: Colors.white)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleIncome(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: showIncome ? Colors.grey[900] : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.yellowAccent),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Expense', style: TextStyle(color: Colors.white)),
                              if (!showIncome)
                                const Icon(Icons.check_circle, color: Colors.yellowAccent, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleIncome(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: showIncome ? const Color(0xFF1A1A1A) : Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.yellowAccent),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Income', style: TextStyle(color: Colors.white)),
                              if (showIncome)
                                const Icon(Icons.check_circle, color: Colors.yellowAccent, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Day', 'Week', 'Month', 'Year'].map((label) {
                  final isActive = label == activePeriod;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        activePeriod = label;
                        _updateDateRange();
                      });
                      _loadTransactions();
                    },
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isActive ? Colors.yellowAccent : Colors.white,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(periodText, style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    CategoryGrid(
                      categories: categories.sublist(0, 4),
                      isIncome: showIncome,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            buildCategoryItem(categories[4]),
                            const SizedBox(height: 12),
                            buildCategoryItem(categories[5]),
                          ],
                        ),
                        const SizedBox(width: 20),
                        buildCircleWithSum(totalAmount),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            buildCategoryItem(categories[6]),
                            const SizedBox(height: 12),
                            buildCategoryItem(categories[7]),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CategoryGrid(
                      categories: categories.sublist(8),
                      isIncome: showIncome,
                    ),
                   /* const SizedBox(height: 12),
                    const Text('All saved transactions:', style: TextStyle(color: Colors.yellowAccent)),
                    ...allTransactions.map((t) => Text(
                      '${t.amount.toStringAsFixed(2)} - ${t.isIncome ? 'income' : 'expense'} - ${DateFormat('dd.MM.yyyy').format(t.date)}',
                      style: const TextStyle(color: Colors.grey),
                    )),   */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Categories'),
    );
  }
}
