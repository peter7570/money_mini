part of '../home_screen.dart';

class HomeHeader extends StatelessWidget {
  final String title;

  const HomeHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.apps, color: Colors.white),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
          const Spacer(),
          const Icon(Icons.compare_arrows, color: Colors.white),
        ],
      ),
    );
  }
}
