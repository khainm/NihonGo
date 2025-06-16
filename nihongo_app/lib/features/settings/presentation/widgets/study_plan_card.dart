import 'package:flutter/material.dart';

class StudyPlanCard extends StatelessWidget {
  final VoidCallback onTap;
  const StudyPlanCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(Icons.calendar_month_rounded, color: Colors.grey),
        title: const Text('Kế hoạch học tập'),
        subtitle: const Text('Thiết lập thời gian và số buổi học', style: TextStyle(fontSize: 13, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
} 