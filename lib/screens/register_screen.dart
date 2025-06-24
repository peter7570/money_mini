// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: const [
                  Icon(Icons.blur_on, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Реєстрація', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Spacer(),
                  Icon(Icons.sync_alt, color: Colors.white)
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Реєстрація',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'Керуйте своїми фінансами легко — почніть зараз!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 20),
              _buildInputField(_nameController, 'Імʼя', Icons.person),
              const SizedBox(height: 12),
              _buildInputField(_emailController, 'Email', Icons.email),
              const SizedBox(height: 12),
              _buildInputField(_passwordController, 'Пароль', Icons.visibility_off, obscure: true),
              const SizedBox(height: 12),
              _buildInputField(_confirmPasswordController, 'Повторіть пароль', Icons.visibility_off, obscure: true),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEDFF8D),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: _register,
                child: const Text('Реєстрація', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('Або продовжити', style: TextStyle(color: Colors.white38)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.white12),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Продовжити з Google', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ваші дані надійно зашифровані й ніколи не передаються третім особам.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text.rich(
                  TextSpan(
                    text: 'Маєте акаунт? ',
                    style: TextStyle(color: Colors.white60),
                    children: [
                      TextSpan(text: 'Вхід', style: TextStyle(color: Color(0xFFEDFF8D))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        suffixIcon: Icon(icon, color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError('Всі поля обовʼязкові');
      return;
    }

    if (password != confirm) {
      _showError('Паролі не співпадають');
      return;
    }

    final box = await Hive.openBox('authBox');
    if (box.containsKey(email)) {
      _showError('Email вже зареєстрований');
      return;
    }

    await box.put(email, password);
    Navigator.pushNamed(context, '/home');
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помилка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
