import 'package:flutter/material.dart';

class TestHistory extends StatelessWidget {
  const TestHistory({Key? key}) : super(key: key);

  final List<_TestHistoryItem> history = const [
    _TestHistoryItem(
      date: '20/11/2023',
      title: 'Kanji N4 - Chương 5',
      score: 92,
    ),
    _TestHistoryItem(
      date: '18/11/2023',
      title: 'Ngữ pháp N4 - Bài 12',
      score: 88,
    ),
    _TestHistoryItem(
      date: '15/11/2023',
      title: 'Từ vựng N4 - Chương 7',
      score: 95,
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
            const Text('Lịch sử kiểm tra', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...history.map((item) => _TestHistoryTile(item: item)),
          ],
        ),
      ),
    );
  }
}

class _TestHistoryItem {
  final String date;
  final String title;
  final int score;

  const _TestHistoryItem({
    required this.date,
    required this.title,
    required this.score,
  });
}

class _TestHistoryTile extends StatelessWidget {
  final _TestHistoryItem item;

  const _TestHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.grey),
      title: Text(item.title),
      subtitle: Text(item.date),
      trailing: Text(
        '${item.score} điểm',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
} 