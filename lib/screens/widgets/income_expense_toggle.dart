import 'package:flutter/material.dart';

class IncomeExpenseToggle extends StatelessWidget {
  final String expenseLabel;
  final String incomeLabel;
  final bool showIncome;
  final ValueChanged<bool> onChanged;

  const IncomeExpenseToggle({
    required this.expenseLabel,
    required this.incomeLabel,
    required this.showIncome,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _toggleButton(expenseLabel, !showIncome, () => onChanged(false)),
          const SizedBox(width: 10),
          _toggleButton(incomeLabel, showIncome, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white24 : Colors.grey.shade800,
            border: Border.all(color: const Color(0xFFEDFF8D)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(
                color: active ? const Color(0xFFEDFF8D) : Colors.white,
                fontWeight: FontWeight.w500,
              )),
              if (label == expenseLabel && active)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check_circle, color: Color(0xFFEDFF8D), size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
