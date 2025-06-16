import 'package:flutter/material.dart';

class DarkModeCard extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onChanged;
  const DarkModeCard({super.key, required this.darkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.nightlight_round, color: Colors.grey),
            const SizedBox(width: 8),
            const Expanded(child: Text('Chế độ tối')),
            Switch(value: darkMode, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
} 