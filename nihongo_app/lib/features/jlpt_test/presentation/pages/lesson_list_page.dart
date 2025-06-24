import 'package:flutter/material.dart';
import '../models/lesson_item.dart';
import '../widgets/lesson_card.dart';

class LessonListPage extends StatefulWidget {
  final String level;
  final String section;

  const LessonListPage({
    super.key,
    required this.level,
    required this.section,
  });

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  late final List<LessonItem> lessons;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual data from API
    lessons = List.generate(
      5,
      (index) => LessonItem(
        title: 'Bài ${index + 1}',
        questionCount: 20,
        duration: 20,
        status: index < 2 ? LessonStatus.completed : LessonStatus.notStarted,
      ),
    );
  }

  void _onStartLesson(int index) {
    // TODO: Implement start lesson logic
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
          '${widget.section} ${widget.level} - Chọn bài kiểm tra',
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
          return LessonCard(
            lesson: lessons[index],
            onStart: () => _onStartLesson(index),
          );
        },
      ),
    );
  }
} 