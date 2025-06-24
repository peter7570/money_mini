import 'package:flutter/material.dart';
import '../summary_screen.dart';
import '../settings_screen.dart';


class BottomNavigation extends StatelessWidget {
  final String activeLabel;

  const BottomNavigation({super.key, required this.activeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            icon: Icons.category,
            label: 'Категорії',
            isActive: activeLabel == 'Categories',
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.account_balance_wallet,
            label: 'Счета',
            isActive: false,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.insert_chart,
            label: 'Статистика',
            isActive: activeLabel == 'Statistics',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SummaryScreen(),
                ),
              );
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.settings,
            label: 'Настройки',
            isActive: activeLabel == 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.yellowAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.yellowAccent : Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
