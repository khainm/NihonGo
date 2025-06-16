import 'package:flutter/material.dart';

class OfflineModeCard extends StatelessWidget {
  final double progress;
  final String size;
  const OfflineModeCard({super.key, required this.progress, required this.size});

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
            const Text('Chế độ ngoại tuyến', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.download_rounded, color: Colors.grey),
                const SizedBox(width: 8),
                const Expanded(child: Text('Tải bài học')),
                Text(size, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF4A90E2),
            ),
            const SizedBox(height: 4),
            const Text('Học mà không cần kết nối mạng', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 