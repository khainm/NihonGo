import 'package:flutter/material.dart';
import '../../domain/entities/listening_lesson.dart';

class ListeningExercise {
  final String audioUrl;
  final String transcript;
  final String transcriptReading;
  final String translation;
  final List<String> questions;

  ListeningExercise({
    required this.audioUrl,
    required this.transcript,
    required this.transcriptReading,
    required this.translation,
    required this.questions,
  });
}

class ListeningLessonDetailPage extends StatelessWidget {
  final ListeningLesson lesson;
  final Color color;

  const ListeningLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  List<ListeningExercise> _getExercises() {
    // Mock data - replace with actual data from API/database later
    return [
      ListeningExercise(
        audioUrl: 'assets/audio/lesson1_1.mp3',
        transcript: '昨日の天気はとても良かったです。',
        transcriptReading: 'きのうのてんきはとてもよかったです。',
        translation: 'Thời tiết hôm qua rất đẹp.',
        questions: [
          'Thời tiết hôm qua như thế nào?',
          'Từ nào trong câu thể hiện mức độ?',
        ],
      ),
      ListeningExercise(
        audioUrl: 'assets/audio/lesson1_2.mp3',
        transcript: '私は毎朝コーヒーを飲みます。',
        transcriptReading: 'わたしはまいあさコーヒーをのみます。',
        translation: 'Tôi uống cà phê mỗi sáng.',
        questions: [
          'Người nói uống gì?',
          'Họ uống vào thời điểm nào?',
        ],
      ),
    ];
  }

  Widget _buildExerciseCard(ListeningExercise exercise, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Câu ${index + 1}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: color,
                  iconSize: 36,
                  onPressed: () {
                    // TODO: Play audio
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.transcript,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.transcriptReading,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.translation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Câu hỏi:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ...exercise.questions.map((question) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.question_mark_rounded, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _getExercises();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${lesson.title} - ${lesson.level}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Navigate to practice/test page
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Luyện tập'),
            style: TextButton.styleFrom(
              foregroundColor: color,
            ),
          ),
        ],
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
                  Icon(Icons.info_outline, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bài luyện nghe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nghe các đoạn hội thoại và trả lời câu hỏi',
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
              itemCount: exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildExerciseCard(exercises[index], index),
            ),
          ],
        ),
      ),
    );
  }
} 