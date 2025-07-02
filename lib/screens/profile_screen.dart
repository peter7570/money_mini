import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  String? _email;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box('users');
    _email = Hive.box('authBox').get('current_user');
    if (_email != null) {
      final user = userBox.get(_email);
      if (user != null && user['name'] != null) {
        _nameController.text = user['name'];
      }
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || _email == null) return;
    final userBox = Hive.box('users');
    final user = userBox.get(_email) ?? {};
    user['name'] = newName;
    userBox.put(_email, user);
    setState(() => _isEditing = false);
  }

  void _openDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailsScreen(email: _email ?? '', name: _nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Профіль', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: _isEditing ? _saveName : _toggleEdit,
          ),
          const SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Налаштування'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _openDetailsScreen,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _isEditing
                          ? TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Імʼя',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.isEmpty ? 'Імʼя не вказано' : _nameController.text,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email ?? '',
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
  final String email;
  final String name;

  const UserDetailsScreen({super.key, required this.email, required this.name});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  void _saveChanges() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;
    final box = Hive.box('users');
    final user = box.get(widget.email) ?? {};
    user['name'] = newName;
    box.put(widget.email, user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Деталі профілю', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Імʼя', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Email: ${widget.email}', style: const TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}
