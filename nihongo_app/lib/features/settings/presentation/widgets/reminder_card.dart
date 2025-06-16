import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback onFrequencyTap;
  final String frequency;
  const ReminderCard({super.key, required this.onScheduleTap, required this.onFrequencyTap, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhắc nhở học tập', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_active_rounded, color: Colors.grey),
              title: const Text('Đặt lịch nhắc nhở'),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              onTap: onScheduleTap,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const SizedBox(width: 24),
              title: const Text('Tần suất nhắc nhở', style: TextStyle(fontSize: 14)),
              subtitle: Text(frequency, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              onTap: onFrequencyTap,
            ),
          ],
        ),
      ),
    );
  }
} 