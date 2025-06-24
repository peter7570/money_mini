import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/category_grid.dart';
import 'widgets/bottom_navigation.dart';

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
  Widget build(BuildContext context) {
    final periodText =
        '${DateFormat('d MMMM').format(startDate)} - ${DateFormat('d MMMM').format(endDate)}';

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
                      onTap: () => setState(() => showIncome = false),
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
                      onTap: () => setState(() => showIncome = true),
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
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Day', 'Week', 'Month', 'Year'].map((label) {
                  final isActive = label == activePeriod;
                  return GestureDetector(
                    onTap: () => setState(() => activePeriod = label),
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
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 12),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    CategoryGrid(
                      categories: categories.sublist(0, 8),
                      isIncome: showIncome,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.yellowAccent.withOpacity(0.3),
                              Colors.black,
                            ],
                            radius: 0.8,
                          ),
                        ),
                        child: const Text(
                          '9 600 ₴',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CategoryGrid(
                      categories: categories.sublist(8),
                      isIncome: showIncome,
                    ),
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
