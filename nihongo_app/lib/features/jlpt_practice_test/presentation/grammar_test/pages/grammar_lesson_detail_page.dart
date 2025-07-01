import 'package:flutter/material.dart';
import '../models/grammar_lesson.dart';

class GrammarPoint {
  final String pattern;
  final String meaning;
  final String explanation;
  final List<GrammarExample> examples;

  GrammarPoint({
    required this.pattern,
    required this.meaning,
    required this.explanation,
    required this.examples,
  });
}

class GrammarExample {
  final String japanese;
  final String reading;
  final String meaning;

  GrammarExample({
    required this.japanese,
    required this.reading,
    required this.meaning,
  });
}

class GrammarLessonDetailPage extends StatelessWidget {
  final GrammarLesson lesson;
  final Color color;

  const GrammarLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  List<GrammarPoint> _getGrammarPoints() {
    // Mock data - replace with actual data from API/database later
    return [
      GrammarPoint(
        pattern: 'は〜です',
        meaning: 'Là (dùng để xác định danh từ)',
        explanation: 'Cấu trúc cơ bản để xác định danh từ trong tiếng Nhật. Thường được dùng để giới thiệu hoặc xác định một điều gì đó.',
        examples: [
          GrammarExample(
            japanese: '私は学生です。',
            reading: 'わたしはがくせいです。',
            meaning: 'Tôi là học sinh.',
          ),
          GrammarExample(
            japanese: 'これは本です。',
            reading: 'これはほんです。',
            meaning: 'Đây là sách.',
          ),
        ],
      ),
      GrammarPoint(
        pattern: '〜ます',
        meaning: 'Thể lịch sự của động từ',
        explanation: 'Đây là dạng lịch sự của động từ, thường được sử dụng trong giao tiếp hàng ngày và trong các tình huống trang trọng.',
        examples: [
          GrammarExample(
            japanese: '毎日勉強します。',
            reading: 'まいにちべんきょうします。',
            meaning: 'Tôi học bài mỗi ngày.',
          ),
          GrammarExample(
            japanese: '日本語を話します。',
            reading: 'にほんごをはなします。',
            meaning: 'Tôi nói tiếng Nhật.',
          ),
        ],
      ),
    ];
  }

  Widget _buildGrammarPointCard(GrammarPoint point) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                point.pattern,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              point.meaning,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              point.explanation,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ví dụ:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...point.examples.map((example) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    example.japanese,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example.reading,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example.meaning,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grammarPoints = _getGrammarPoints();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${lesson.title} - ${lesson.level}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Navigate to practice/test page
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Luyện tập'),
            style: TextButton.styleFrom(
              foregroundColor: color,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Điểm ngữ pháp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Học các điểm ngữ pháp dưới đây và nhấn "Luyện tập" để kiểm tra',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grammarPoints.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildGrammarPointCard(grammarPoints[index]),
            ),
          ],
        ),
      ),
    );
  }
} 