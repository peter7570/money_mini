import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: const [
              SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.apps, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Політика конфедеційності',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  Icon(Icons.sync_alt, color: Colors.white)
                ],
              ),
              SizedBox(height: 24),
              Text(
                'MoneyNest поважає вашу конфіденційність і дбає про безпеку ваших даних. Ми зобов’язуємось захищати вашу інформацію відповідно до чинного законодавства.',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24),
              Text(
                '1. Яку інформацію ми збираємо:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '• Ім’я та електронну пошту (якщо ви реєструєтесь)\n• Дані про використання додатку (для покращення сервісу)\n• Жодна фінансова інформація (наприклад, паролі до банків) не зберігається на наших серверах',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '2. Як ми використовуємо інформацію:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '• Щоб надати вам доступ до функцій додатку\n• Щоб покращити зручність використання\n• Для надсилання важливих оновлень або повідомлень',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '3. Кому ми передаємо дані:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ми не продаємо і не передаємо ваші персональні дані третім особам.',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '4. Безпека:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ми використовуємо сучасні заходи захисту для збереження вашої інформації.',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '5. Ваші права:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ви маєте право:\n• Переглянути, змінити або видалити свої дані\n• Написати нам, якщо у вас є питання або скарги щодо конфіденційності',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                '6. Контакти:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Зв’яжіться з нами: \nsupport@moneynest.app',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(activeLabel: 'Настройки'),
    );
  }
}
