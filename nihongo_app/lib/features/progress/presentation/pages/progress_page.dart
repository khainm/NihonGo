import 'package:flutter/material.dart';
import '../widgets/progress_tab_bar.dart';
import '../widgets/progress_overview.dart';
import '../widgets/recent_activities.dart';
import '../widgets/test_history.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiến độ học tập'),
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
    );
  }
} 