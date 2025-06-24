import 'package:flutter/material.dart';

class DateRangeButton extends StatelessWidget {
  final String periodText;

  const DateRangeButton({required this.periodText, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
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
    );
  }
}
