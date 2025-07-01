import 'package:flutter/material.dart';
import '../../domain/entities/vocabulary_lesson.dart';
import '../widgets/vocabulary_lesson_card.dart';
import 'vocabulary_lesson_detail_page.dart';

class VocabularyLessonsPage extends StatelessWidget {
  final String level;
  final String subtitle;
  final Color color;

  const VocabularyLessonsPage({
    super.key,
    required this.level,
    required this.subtitle,
    required this.color,
  });

  List<VocabularyLesson> _getMockLessons() {
    // Mock data - sẽ thay thế bằng data thực từ API/database
    return List.generate(6, (index) {
      final totalWords = 15 + (index * 2);
      final completedWords = index * 3;
      
      return VocabularyLesson(
        id: index + 1,
        title: 'Bài ${index + 1}',
        description: _getLessonDescription(index),
        totalWords: totalWords,
        completedWords: completedWords,
        level: level,
        estimatedTime: Duration(minutes: 20 + (index * 5)),
        words: _getMockWords(index + 1, totalWords),
      );
    });
  }

  String _getLessonDescription(int index) {
    final topics = [
      'Giới thiệu bản thân và gia đình',
      'Thời gian và ngày tháng',
      'Đồ ăn và thức uống',
      'Giao thông và phương tiện',
      'Mua sắm và tiền bạc',
      'Thời tiết và mùa',
    ];
    return topics[index % topics.length];
  }

  List<VocabularyWord> _getMockWords(int lessonId, int count) {
    final words = [
      {'word': '私', 'reading': 'わたし', 'meaning': 'tôi', 'example': '私は学生です。', 'translation': 'Tôi là học sinh.'},
      {'word': '今日', 'reading': 'きょう', 'meaning': 'hôm nay', 'example': '今日は晴れです。', 'translation': 'Hôm nay trời nắng.'},
      {'word': '食べる', 'reading': 'たべる', 'meaning': 'ăn', 'example': 'パンを食べます。', 'translation': 'Tôi ăn bánh mì.'},
      {'word': '行く', 'reading': 'いく', 'meaning': 'đi', 'example': '学校に行きます。', 'translation': 'Tôi đi học.'},
      {'word': '買う', 'reading': 'かう', 'meaning': 'mua', 'example': '本を買います。', 'translation': 'Tôi mua sách.'},
    ];

    return List.generate(count, (index) {
      final wordData = words[index % words.length];
      return VocabularyWord(
        id: (lessonId * 100) + index,
        word: wordData['word']!,
        reading: wordData['reading']!,
        meaning: wordData['meaning']!,
        example: wordData['example']!,
        exampleTranslation: wordData['translation']!,
        tags: ['Cơ bản', level],
        isLearned: index < (lessonId - 1) * 3,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _getMockLessons();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Từ vựng $level',
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
                  Icon(Icons.menu_book, color: color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Học từ vựng theo chủ đề',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Học từ vựng cơ bản với ví dụ và cách sử dụng',
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
                          '${lessons.fold(0, (sum, l) => sum + l.completedWords)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const Text(
                          'Từ đã học',
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
                          '${lessons.fold(0, (sum, l) => sum + l.totalWords)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const Text(
                          'Tổng từ vựng',
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
                return VocabularyLessonCard(
                  lesson: lessons[index],
                  color: color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VocabularyLessonDetailPage(
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
