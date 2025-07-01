import 'package:flutter/material.dart';
import '../models/listening_lesson.dart';
import '../widgets/listening_lesson_card.dart';

class ListeningLessonListPage extends StatefulWidget {
  final String level;

  const ListeningLessonListPage({
    super.key,
    required this.level,
  });

  @override
  State<ListeningLessonListPage> createState() => _ListeningLessonListPageState();
}

class _ListeningLessonListPageState extends State<ListeningLessonListPage> {
  late final List<ListeningLesson> lessons;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual data from API
    lessons = List.generate(
      5,
      (index) => ListeningLesson(
        title: 'Bài ${index + 1}',
        questionCount: 15,
        duration: 30,
        isCompleted: index < 2,
      ),
    );
  }

  void _onStartLesson(int index) {
    // TODO: Navigate to listening test page
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
          'Nghe hiểu ${widget.level} - Chọn bài kiểm tra',
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
          return ListeningLessonCard(
            lesson: lessons[index],
            onStart: () => _onStartLesson(index),
          );
        },
      ),
    );
  }
} 