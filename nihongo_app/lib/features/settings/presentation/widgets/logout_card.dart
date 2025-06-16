import 'package:flutter/material.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: const Icon(Icons.logout_rounded, color: Colors.red),
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.red),
        onTap: onTap,
      ),
    );
  }
} 