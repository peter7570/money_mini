import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.apps, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Допомога',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.sync_alt, color: Colors.white),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Зв\'яжіться з нами:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'support@moneynest.app',
                style: TextStyle(
                  color: Color(0xFFEDFF8D),
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Настройки'),
    );
  }
}
