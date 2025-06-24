import 'package:flutter/material.dart';
import '../models/vocabulary_lesson.dart';
import '../widgets/vocabulary_lesson_card.dart';

class VocabularyLessonListPage extends StatefulWidget {
  final String level;

  const VocabularyLessonListPage({
    super.key,
    required this.level,
  });

  @override
  State<VocabularyLessonListPage> createState() => _VocabularyLessonListPageState();
}

class _VocabularyLessonListPageState extends State<VocabularyLessonListPage> {
  late final List<VocabularyLesson> lessons;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual data from API
    lessons = List.generate(
      5,
      (index) => VocabularyLesson(
        title: 'Bài ${index + 1}',
        questionCount: 25,
        duration: 15,
        isCompleted: index < 2,
      ),
    );
  }

  void _onStartLesson(int index) {
    // TODO: Navigate to vocabulary test page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Từ vựng ${widget.level} - Chọn bài kiểm tra',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return VocabularyLessonCard(
            lesson: lessons[index],
            onStart: () => _onStartLesson(index),
          );
        },
      ),
    );
  }
} 