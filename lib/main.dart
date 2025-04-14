import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('transactions');
  runApp(MyApp());
}

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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniMoney',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Transaction> transactions = [];

  final List<String> categories = [
    'Еда',
    'Транспорт',
    'Покупки',
    'Развлечения',
    'Зарплата',
    'Прочее',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final box = Hive.box('transactions');
    final loaded =
        box.values.map((item) {
          final map = Map<String, dynamic>.from(item);
          return Transaction(
            title: map['title'],
            amount: map['amount'],
            isIncome: map['isIncome'],
            category: map['category'],
          );
        }).toList();

    setState(() {
      transactions = loaded;
    });
  }

  void _addTransaction(Transaction tx) async {
    final box = Hive.box('transactions');
    await box.add({
      'title': tx.title,
      'amount': tx.amount,
      'isIncome': tx.isIncome,
      'category': tx.category,
    });

    setState(() {
      transactions.add(tx);
    });
  }

  void _editTransaction(int index, Transaction updatedTx) async {
    final box = Hive.box('transactions');
    final key = box.keyAt(index);
    await box.put(key, {
      'title': updatedTx.title,
      'amount': updatedTx.amount,
      'isIncome': updatedTx.isIncome,
      'category': updatedTx.category,
    });

    setState(() {
      transactions[index] = updatedTx;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      TransactionListScreen(
        transactions: transactions,
        onAdd: _addTransaction,
        onEdit: _editTransaction,
        categories: categories,
      ),
      StatisticsScreen(transactions: transactions),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(icon: Icon(Icons.list), label: 'Транзакции'),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            label: 'Статистика',
          ),
        ],
      ),
    );
  }
}

class TransactionListScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onAdd;
  final Function(int, Transaction) onEdit;
  final List<String> categories;

  TransactionListScreen({
    required this.transactions,
    required this.onAdd,
    required this.onEdit,
    required this.categories,
  });

  void _showAddDialog(BuildContext context) {
    _showTransactionDialog(context, isEdit: false);
  }

  void _showEditDialog(BuildContext context, int index, Transaction tx) {
    _showTransactionDialog(
      context,
      isEdit: true,
      transaction: tx,
      index: index,
    );
  }

  void _showTransactionDialog(
    BuildContext context, {
    required bool isEdit,
    Transaction? transaction,
    int? index,
  }) {
    String title = transaction?.title ?? '';
    String amount = transaction?.amount.toString() ?? '';
    bool isIncome = transaction?.isIncome ?? true;
    String category = transaction?.category ?? categories.first;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(isEdit ? 'Редактировать' : 'Добавить операцию'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: TextEditingController(text: title),
                          decoration: InputDecoration(labelText: 'Название'),
                          onChanged: (value) => title = value,
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: TextEditingController(text: amount),
                          decoration: InputDecoration(labelText: 'Сумма'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => amount = value,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Тип: '),
                            Expanded(
                              child: DropdownButton<bool>(
                                value: isIncome,
                                onChanged: (value) {
                                  if (value != null) {
                                    setDialogState(() => isIncome = value);
                                  }
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Доход'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('Расход'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Категория: '),
                            Expanded(
                              child: DropdownButton<String>(
                                value: category,
                                onChanged: (value) {
                                  if (value != null) {
                                    setDialogState(() => category = value);
                                  }
                                },
                                items:
                                    categories
                                        .map(
                                          (cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Отмена'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text(isEdit ? 'Сохранить' : 'Добавить'),
                      onPressed: () {
                        if (title.isNotEmpty &&
                            double.tryParse(amount) != null) {
                          final tx = Transaction(
                            title: title,
                            amount: double.parse(amount),
                            isIncome: isIncome,
                            category: category,
                          );
                          if (isEdit && index != null) {
                            onEdit(index, tx);
                          } else {
                            onAdd(tx);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Транзакции')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () => _showEditDialog(context, index, tx),
                leading: Icon(
                  tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: tx.isIncome ? Colors.green : Colors.red,
                ),
                title: Text(
                  tx.title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${tx.amount.toStringAsFixed(2)} грн • ${tx.category}',
                ),
                trailing: Text(
                  tx.isIncome ? 'Доход' : 'Расход',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tx.isIncome ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: Icon(Icons.add),
        label: Text('Операция'),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  StatisticsScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    Map<String, double> data = {};

    for (var tx in transactions) {
      if (!tx.isIncome) {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }

    final total = data.values.fold(0.0, (sum, item) => sum + item);

    return Scaffold(
      appBar: AppBar(title: Text('Статистика')),
      body:
          data.isEmpty
              ? Center(child: Text('Нет данных для отображения'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    sections:
                        data.entries.map((entry) {
                          final percent = (entry.value / total) * 100;
                          return PieChartSectionData(
                            value: entry.value,
                            title:
                                '${entry.key}\n${percent.toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }
}
