import 'package:flutter/material.dart';
import '../summary_screen.dart';
import '../settings_screen.dart';
import '../home_screen.dart';

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
            iconPath: 'assets/icons/categories.png',
            label: 'Категорії',
            isActive: activeLabel == 'Categories',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/icons/scheta.png',
            label: 'Счета',
            isActive: false,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/icons/statisctic.png',
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
            iconPath: 'assets/icons/proper.png',
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
        required String iconPath,
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
            child: Image.asset(
              iconPath,
              width: 60,
              height: 60,
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
