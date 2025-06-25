import 'package:flutter/material.dart';
import '../models/grammar_lesson.dart';
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

  List<GrammarLesson> _getLessons() {
    // Mock data - replace with actual data from API/database later
    return List.generate(5, (index) {
      return GrammarLesson(
        id: index + 1,
        title: 'Bài ${index + 1}',
        description: 'Ngữ pháp cơ bản ${index + 1}',
        totalPoints: 20,
        completedPoints: index * 4,
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
              'Ngữ pháp $level',
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
                  Icon(Icons.school, color: color, size: 24),
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
                          'Hoàn thành các bài học để nâng cao kỹ năng ngữ pháp',
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