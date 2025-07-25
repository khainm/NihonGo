import 'package:flutter/material.dart';
import '../../../../features/jlpt_practice_test/presentation/grammar_test/pages/grammar_lessons_page.dart' as JLPTGrammar;
import '../../../../features/learning_lessons/grammar/presentation/pages/grammar_lessons_page.dart' as LearningGrammar;
import '../../../../features/learning_lessons/kanji/presentation/pages/kanji_lessons_page.dart';
import '../../../../features/learning_lessons/listening/presentation/pages/listening_lessons_page.dart';

class LevelDetailPage extends StatelessWidget {
  final String level;
  final String subtitle;
  final Color color;

  const LevelDetailPage({
    super.key,
    required this.level,
    required this.subtitle,
    required this.color,
  });

  Widget _buildStudySection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bắt đầu học $title $level',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              level,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '- $subtitle',
              style: const TextStyle(
                fontSize: 16,
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
            const Text(
              'Chọn phần học',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStudySection(
              title: 'Từ vựng',
              icon: Icons.menu_book,
              onTap: () {
                // Navigate to JLPT levels page for all levels
                Navigator.pushNamed(context, '/jlpt-levels');
              },
            ),
            const SizedBox(height: 12),
            _buildStudySection(
              title: 'Ngữ pháp',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningGrammar.GrammarLessonsPage(
                      level: level,
                      subtitle: subtitle,
                      color: color,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildStudySection(
              title: 'Kanji',
              icon: Icons.brush,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KanjiLessonsPage(
                      level: level,
                      subtitle: subtitle,
                      color: color,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildStudySection(
              title: 'Luyện nghe',
              icon: Icons.headphones,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListeningLessonsPage(
                      level: level,
                      subtitle: subtitle,
                      color: color,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Luyện thi JLPT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStudySection(
              title: 'Đề thi ngữ pháp JLPT',
              icon: Icons.quiz,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JLPTGrammar.GrammarLessonsPage(
                      level: level,
                      subtitle: subtitle,
                      color: color,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 