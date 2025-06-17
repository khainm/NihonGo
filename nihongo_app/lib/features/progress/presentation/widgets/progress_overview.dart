import 'package:flutter/material.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levels = [
      {'label': 'N5 - Sơ cấp', 'percent': 1.0},
      {'label': 'N4 - Sơ trung cấp', 'percent': 0.85},
      {'label': 'N3 - Trung cấp', 'percent': 0.6},
      {'label': 'N2 - Cao cấp', 'percent': 0.25},
      {'label': 'N1 - Cao cấp nâng cao', 'percent': 0.05},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Tổng quan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 0.78,
                    strokeWidth: 8,
                  ),
                  const Text('78%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('234/300 bài học hoàn thành'),
            const SizedBox(height: 16),
            ...levels.map((level) => _LevelProgressBar(
              label: level['label'] as String,
              percent: level['percent'] as double,
            )),
          ],
        ),
      ),
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  final String label;
  final double percent;

  const _LevelProgressBar({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(value: percent),
          ),
          const SizedBox(width: 8),
          Text('${(percent * 100).toInt()}%'),
        ],
      ),
    );
  }
} 