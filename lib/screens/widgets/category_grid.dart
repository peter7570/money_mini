import 'package:flutter/material.dart';
import '../add_transaction_screen.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final bool isIncome;
  final bool isVertical;

  const CategoryGrid({
    required this.categories,
    required this.isIncome,
    this.isVertical = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isVertical ? 1 : 4;
    final aspectRatio = isVertical ? 1.8 : 0.85;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final String iconPath = category['iconPath'] ?? '';
        final String label = category['label'] ?? '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTransactionScreen(
                  category: category,
                  isIncome: isIncome,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: iconPath.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                )
                    : const SizedBox(),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 72,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
