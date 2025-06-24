import 'package:flutter/material.dart';
import '../widgets/progress_tab_bar.dart';
import '../widgets/progress_overview.dart';
import '../widgets/recent_activities.dart';
import '../widgets/test_history.dart';
import '../../../../shared/widgets/app_bottom_navigation_bar.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _currentIndex = 2; // Set to 2 for Progress tab

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tiến độ học tập',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            ProgressTabBar(),
            SizedBox(height: 16),
            ProgressOverview(),
            SizedBox(height: 16),
            RecentActivities(),
            SizedBox(height: 16),
            TestHistory(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
} 