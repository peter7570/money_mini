import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.apps, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Настройки',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.sync_alt, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildItem(context, 'Профіль', '/profile'),
                  _buildItem(context, 'Данные', '/data'),
                  _buildItem(context, 'Языки', '/languages'),
                  _buildItem(context, 'Валюты', '/currencies'),
                  _buildItem(context, 'Політика конфедеційності', '/privacy'),
                  _buildItem(context, 'Допомога', '/help'),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Настройки'),
    );
  }

  Widget _buildItem(BuildContext context, String title, String route) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white),
          onTap: () => _navigate(context, route),
        ),
        const Divider(color: Colors.white24, height: 1),
      ],
    );
  }
}
