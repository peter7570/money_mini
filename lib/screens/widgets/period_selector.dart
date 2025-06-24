import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final List<String> labels;
  final String activePeriod;
  final ValueChanged<String> onChanged;

  const PeriodSelector({
    required this.labels,
    required this.activePeriod,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: labels.map((period) {
          return GestureDetector(
            onTap: () => onChanged(period),
            child: Text(
              period,
              style: TextStyle(
                color: activePeriod == period ? const Color(0xFFEDFF8D) : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
