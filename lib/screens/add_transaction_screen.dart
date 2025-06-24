import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/bottom_navigation.dart';

class AddTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  final bool isIncome;

  const AddTransactionScreen({
    required this.category,
    required this.isIncome,
    super.key,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  XFile? _selectedImage;
  final List<String> _tags = [];
  bool showAllCategories = false;
  late bool _isIncome;

  final List<Map<String, dynamic>> categories = [
    {'label': 'Health',    'iconPath': 'assets/icons/health.png',    'color': Color(0xFFFF8A80)},
    {'label': 'Home',      'iconPath': 'assets/icons/home.png',      'color': Color(0xFFB39DDB)},
    {'label': 'Expenses',  'iconPath': 'assets/icons/expenses.png',  'color': Color(0xFFD7CCC8)},
    {'label': 'Cafe',      'iconPath': 'assets/icons/cafe.png',      'color': Color(0xFFDCEDC8)},
    {'label': 'Education', 'iconPath': 'assets/icons/education.png', 'color': Color(0xFF80DEEA)},
    {'label': 'Products',  'iconPath': 'assets/icons/products.png',  'color': Color(0xFFFFCC80)},
    {'label': 'Gifts',     'iconPath': 'assets/icons/gifts.png',     'color': Color(0xFFE1BEE7)},
    {'label': 'Transport', 'iconPath': 'assets/icons/transport.png', 'color': Color(0xFF90CAF9)},
    {'label': 'Travel',    'iconPath': 'assets/icons/travel.png',    'color': Color(0xFF4DD0E1)},
    {'label': 'Sports',    'iconPath': 'assets/icons/sports.png',    'color': Color(0xFFFFAB91)},
    {'label': 'Pets',      'iconPath': 'assets/icons/pets.png',      'color': Color(0xFFCE93D8)},
    {'label': 'Car',       'iconPath': 'assets/icons/car.png',       'color': Color(0xFF81D4FA)},
  ];

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncome;
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _addTag() {
    showDialog(
      context: context,
      builder: (context) {
        final tagController = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Add Tag', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: tagController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter tag',
              hintStyle: TextStyle(color: Colors.white24),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tagController.text.isNotEmpty) {
                  setState(() => _tags.add(tagController.text));
                }
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: Colors.yellowAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryTile(String iconPath, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 28, // ограничим высоту
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }



  void _saveTransaction() {
    final amount = _amountController.text.trim();
    final comment = _commentController.text.trim();
    if (amount.isEmpty || double.tryParse(amount.replaceAll(',', '.')) == null) return;

    final transaction = {
      'amount': double.parse(amount.replaceAll(',', '.')),
      'date': selectedDate,
      'tags': _tags,
      'comment': comment,
      'photo': _selectedImage?.path,
      'category': widget.category,
      'type': _isIncome ? 'income' : 'expense',
    };

    Navigator.pushNamed(context, '/analytics', arguments: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final visibleCategories = showAllCategories ? categories : categories.take(8).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeButton('Expense', !_isIncome),
                const SizedBox(width: 8),
                _buildTypeButton('Income', _isIncome),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 36),
                    decoration: const InputDecoration(
                      hintText: '__',
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 36),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Text('USD', style: TextStyle(color: Colors.yellowAccent, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _selectDate,
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Категорії', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // было 0.8 — немного увеличили
              physics: const NeverScrollableScrollPhysics(),
              children: visibleCategories.map((cat) {
                return _buildCategoryTile(
                  cat['iconPath'],
                  cat['label'],
                  cat['color'],
                );
              }).toList(),
            ),

            if (!showAllCategories)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () => setState(() => showAllCategories = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Всі категорії', style: TextStyle(color: Colors.white)),
                ),
              ),
            const SizedBox(height: 32),
            const Text('Теги', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._tags.map((tag) => Chip(label: Text(tag))),
                OutlinedButton.icon(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add, color: Colors.yellowAccent),
                  label: const Text('Добавить тег', style: TextStyle(color: Colors.yellowAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.yellowAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Коментар', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Напишіть......',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Фото', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellowAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null && index == 0
                        ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                        : const Icon(Icons.add, color: Colors.yellowAccent),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7FF5C),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Добавить', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Категорії'),
    );
  }

  Widget _buildTypeButton(String label, bool isActive) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() => _isIncome = (label == 'Income'));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          side: BorderSide(color: isActive ? Colors.yellowAccent : Colors.transparent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            if (isActive) const Icon(Icons.check_circle, color: Colors.yellowAccent, size: 16),
          ],
        ),
      ),
    );
  }
}
