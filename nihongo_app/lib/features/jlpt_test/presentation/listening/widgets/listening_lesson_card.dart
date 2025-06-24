import 'package:flutter/material.dart';
import '../models/listening_lesson.dart';

class ListeningLessonCard extends StatelessWidget {
  final ListeningLesson lesson;
  final VoidCallback onStart;

  const ListeningLessonCard({
    super.key,
    required this.lesson,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  lesson.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: lesson.isCompleted ? Colors.green : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.help_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${lesson.questionCount} câu hỏi',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${lesson.duration} phút',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  lesson.isCompleted ? 'Làm lại' : 'Bắt đầu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 