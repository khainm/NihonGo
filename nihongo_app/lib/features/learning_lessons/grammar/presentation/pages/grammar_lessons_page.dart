import 'package:flutter/material.dart';
import '../../domain/entities/grammar_lesson.dart';
import '../widgets/grammar_lesson_card.dart';
import 'grammar_lesson_detail_page.dart';

class GrammarLessonsPage extends StatelessWidget {
  final String level;
  final String subtitle;
  final Color color;

  const GrammarLessonsPage({
    super.key,
    required this.level,
    required this.subtitle,
    required this.color,
  });

  List<GrammarLesson> _getMockLessons() {
    // Mock data - sẽ thay thế bằng data thực từ API/database
    return List.generate(8, (index) {
      final categories = ['Particles', 'Verb Forms', 'Adjectives', 'Sentence Patterns'];
      final totalPoints = 4 + index;
      final completedPoints = index * 2;
      
      return GrammarLesson(
        id: index + 1,
        title: 'Bài ${index + 1}',
        description: _getLessonDescription(index),
        level: level,
        category: categories[index % categories.length],
        totalGrammarPoints: totalPoints,
        completedGrammarPoints: completedPoints,
        estimatedTime: Duration(minutes: 25 + (index * 5)),
        grammarPoints: _getMockGrammarPoints(index + 1, totalPoints),
      );
    });
  }

  String _getLessonDescription(int index) {
    final descriptions = [
      'Học cách sử dụng các trợ từ cơ bản は, が, を',
      'Chia động từ thì hiện tại và quá khứ',
      'Tính từ -i và -na: cách sử dụng và chia',
      'Cấu trúc câu cơ bản với です/である',
      'Biểu hiện ý kiến và cảm xúc',
      'Câu điều kiện đơn giản với たら',
      'So sánh với より và のほうが',
      'Biểu hiện khả năng với ことができる',
    ];
    return descriptions[index % descriptions.length];
  }

  List<GrammarPoint> _getMockGrammarPoints(int lessonId, int count) {
    final patterns = [
      {'pattern': 'は', 'meaning': 'Trợ từ chỉ chủ đề', 'explanation': 'Dùng để chỉ chủ đề của câu'},
      {'pattern': 'が', 'meaning': 'Trợ từ chỉ chủ ngữ', 'explanation': 'Dùng để chỉ chủ ngữ thực hiện hành động'},
      {'pattern': 'を', 'meaning': 'Trợ từ chỉ đối tượng', 'explanation': 'Dùng để chỉ đối tượng của hành động'},
      {'pattern': 'です', 'meaning': 'Động từ copula lịch sự', 'explanation': 'Dùng để kết thúc câu một cách lịch sự'},
      {'pattern': 'ます', 'meaning': 'Thể lịch sự của động từ', 'explanation': 'Thêm vào cuối động từ để tạo thể lịch sự'},
    ];

    return List.generate(count, (index) {
      final patternData = patterns[index % patterns.length];
      return GrammarPoint(
        id: (lessonId * 100) + index,
        pattern: patternData['pattern']!,
        meaning: patternData['meaning']!,
        explanation: patternData['explanation']!,
        usage: 'Sử dụng trong câu để ${patternData['meaning']!.toLowerCase()}',
        formationRule: 'Đặt sau danh từ hoặc động từ',
        examples: [
          GrammarExample(
            id: 1,
            japanese: '私は学生です。',
            romaji: 'Watashi wa gakusei desu.',
            translation: 'Tôi là học sinh.',
            highlightedPart: 'は',
            context: 'Giới thiệu bản thân',
          ),
        ],
        relatedPatterns: ['が', 'も', 'の'],
        notes: ['Không đọc là "ha" mà đọc là "wa" khi làm trợ từ'],
        isLearned: index < (lessonId - 1) * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _getMockLessons();
    final categories = lessons.map((l) => l.category).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ngữ pháp $level',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.school, color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Học ngữ pháp từ cơ bản',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Giải thích chi tiết với ví dụ và cách sử dụng',
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
            
            // Progress overview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${lessons.where((l) => l.isCompleted).length}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const Text(
                          'Bài hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${lessons.fold(0, (sum, l) => sum + l.completedGrammarPoints)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const Text(
                          'Điểm ngữ pháp',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${categories.length}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const Text(
                          'Chủ đề',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Categories overview
            Text(
              'Chủ đề ngữ pháp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final categoryLessons = lessons.where((l) => l.category == category).length;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$categoryLessons',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Lessons list
            Text(
              'Danh sách bài học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return GrammarLessonCard(
                  lesson: lessons[index],
                  color: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrammarLessonDetailPage(
                          lesson: lessons[index],
                          color: color,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
