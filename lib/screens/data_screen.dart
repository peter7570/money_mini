import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/bottom_navigation.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Box? box;
  Map? currentUser;

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    box = await Hive.openBox('users');
    if (box!.containsKey('current_user')) {
      final email = box!.get('current_user');
      final user = box!.get(email);
      if (user is Map) {
        setState(() {
          currentUser = user;
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: box == null
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : Column(
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
                    'Дані',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.sync_alt, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (currentUser != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.deepPurple,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      currentUser!['name'] ?? 'Поточний профіль',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currentUser!['email'] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Настройки'),
    );
  }
}
