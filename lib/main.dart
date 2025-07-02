// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';

import 'screens/onboarding_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/data_screen.dart';
import 'screens/help_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_code_screen.dart';
import 'screens/reset_password_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //await Hive.deleteBoxFromDisk('transactions');

  await Hive.openBox('authBox');
  await Hive.openBox('users');
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyNest',
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/summary': (context) => const SummaryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/data': (context) => const DataScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/help': (context) => const HelpScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/verifyEmail': (context) => const VerifyCodeScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/analytics': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AnalyticsScreen(transaction: args);
        },
      },
    );
  }
}
