import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/jlpt_test/presentation/pages/jlpt_test_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget? nextPage;
    switch (index) {
      case 0:
        if (currentIndex != 0) {
          nextPage = const HomePage();
        }
        break;
      case 1:
        nextPage = const JLPTTestPage();
        break;
      case 2:
        nextPage = const ProgressPage();
        break;
      case 3:
        nextPage = const SettingsPage();
        break;
    }

    if (nextPage != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => nextPage!),
      );
    }
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4A90E2),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Học tập',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_rounded),
          label: 'Kiểm tra',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Tiến độ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Cài đặt',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
    );
  }
} 