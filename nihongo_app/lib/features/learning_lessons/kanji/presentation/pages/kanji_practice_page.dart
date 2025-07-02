import 'package:flutter/material.dart';
import '../../domain/entities/kanji_lesson.dart';
import '../widgets/practice_card.dart';
import '../widgets/kanji_flashcard.dart';
import '../widgets/kanji_quiz_card.dart';
import '../widgets/stroke_order_practice.dart';
import '../widgets/practice_stats_card.dart';

class KanjiPracticePage extends StatefulWidget {
  final KanjiLesson lesson;
  final Color color;

  const KanjiPracticePage({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<KanjiPracticePage> createState() => _KanjiPracticePageState();
}

class _KanjiPracticePageState extends State<KanjiPracticePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> practiceTypes = [
    {
      'title': 'Flashcard',
      'description': 'Học từ vựng qua thẻ ghi nhớ',
      'icon': Icons.credit_card,
      'color': const Color(0xFF4A90E2),
    },
    {
      'title': 'Trắc nghiệm',
      'description': 'Kiểm tra kiến thức qua câu hỏi',
      'icon': Icons.quiz,
      'color': const Color(0xFF3ED598),
    },
    {
      'title': 'Viết nét',
      'description': 'Luyện viết thứ tự nét',
      'icon': Icons.brush,
      'color': const Color(0xFFFFC542),
    },
    {
      'title': 'Thống kê',
      'description': 'Xem tiến độ học tập',
      'icon': Icons.bar_chart,
      'color': const Color(0xFFB620E0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Luyện tập ${widget.lesson.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              '${widget.lesson.completedKanji}/${widget.lesson.totalKanji} Kanji',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tiến độ học tập',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${((widget.lesson.completedKanji / widget.lesson.totalKanji) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.lesson.completedKanji / widget.lesson.totalKanji,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          
          // Practice Options
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildPracticeMenu(),
                KanjiFlashcard(lesson: widget.lesson, color: widget.color),
                KanjiQuizCard(lesson: widget.lesson, color: widget.color),
                StrokeOrderPractice(lesson: widget.lesson, color: widget.color),
                PracticeStatsCard(lesson: widget.lesson, color: widget.color),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final isActive = index == _currentIndex;
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? widget.color.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getIconForIndex(index),
                  color: isActive ? widget.color : Colors.grey,
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPracticeMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn phương thức luyện tập',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy chọn cách thức phù hợp để luyện tập Kanji hiệu quả nhất',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: practiceTypes.length,
            itemBuilder: (context, index) {
              final practiceType = practiceTypes[index];
              return PracticeCard(
                title: practiceType['title'],
                description: practiceType['description'],
                icon: practiceType['icon'],
                color: practiceType['color'],
                onTap: () {
                  _pageController.animateToPage(
                    index + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.apps;
      case 1:
        return Icons.credit_card;
      case 2:
        return Icons.quiz;
      case 3:
        return Icons.brush;
      case 4:
        return Icons.bar_chart;
      default:
        return Icons.apps;
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hướng dẫn luyện tập'),
        content: const Text(
          'Chọn một trong các phương thức luyện tập:\n\n'
          '• Flashcard: Ôn tập từ vựng qua thẻ ghi nhớ\n'
          '• Trắc nghiệm: Kiểm tra kiến thức qua câu hỏi\n'
          '• Viết nét: Luyện viết thứ tự nét chuẩn\n'
          '• Thống kê: Xem tiến độ và kết quả học tập',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }
}
