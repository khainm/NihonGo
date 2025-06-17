import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({Key? key}) : super(key: key);

  final List<_Activity> activities = const [
    _Activity(
      icon: Icons.emoji_events,
      title: 'Bài kiểm tra Kanji N4',
      subtitle: '98 điểm',
      completed: true,
    ),
    _Activity(
      icon: Icons.check_circle,
      title: 'Ngữ pháp N4 - Bài 15',
      subtitle: 'Hoàn thành',
      completed: true,
    ),
    _Activity(
      icon: Icons.menu_book,
      title: 'Từ vựng N4 - Chương 8',
      subtitle: '85 điểm',
      completed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hoạt động gần đây', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...activities.map((activity) => _ActivityTile(activity: activity)),
          ],
        ),
      ),
    );
  }
}

class _Activity {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool completed;

  const _Activity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completed,
  });
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(activity.icon, color: activity.completed ? Colors.blue : Colors.grey),
      title: Text(activity.title),
      subtitle: Text(activity.subtitle),
      trailing: activity.completed
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
} 