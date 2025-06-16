import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String email;
  final String level;
  final VoidCallback? onEdit;
  const ProfileHeader({super.key, required this.avatarUrl, required this.name, required this.email, required this.level, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        Text(email, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(level, style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
        ),
        if (onEdit != null)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF4A90E2)),
              onPressed: onEdit,
            ),
          ),
      ],
    );
  }
} 