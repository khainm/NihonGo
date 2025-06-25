import 'package:flutter/material.dart';
import '../models/vocabulary_lesson.dart';
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

  List<VocabularyLesson> _getLessons() {
    // Mock data - replace with actual data from API/database later
    return List.generate(5, (index) {
      return VocabularyLesson(
        id: index + 1,
        title: 'Bài ${index + 1}',
        description: 'Từ vựng cơ bản về chủ đề ${index + 1}',
        totalWords: 20,
        completedWords: index * 4,
        level: level,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _getLessons();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Từ vựng $level',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
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
                          'Danh sách bài học',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hoàn thành các bài học để nâng cao vốn từ vựng',
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