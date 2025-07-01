import 'package:flutter/material.dart';
import '../models/vocabulary_lesson.dart';

class VocabularyWord {
  final String word;
  final String reading;
  final String meaning;
  final String example;
  final String exampleReading;
  final String exampleMeaning;

  VocabularyWord({
    required this.word,
    required this.reading,
    required this.meaning,
    required this.example,
    required this.exampleReading,
    required this.exampleMeaning,
  });
}

class VocabularyLessonDetailPage extends StatelessWidget {
  final VocabularyLesson lesson;
  final Color color;

  const VocabularyLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  List<VocabularyWord> _getWords() {
    // Mock data - replace with actual data from API/database later
    return [
      VocabularyWord(
        word: '食べる',
        reading: 'たべる',
        meaning: 'Ăn',
        example: '朝ご飯を食べます。',
        exampleReading: 'あさごはんをたべます。',
        exampleMeaning: 'Tôi ăn bữa sáng.',
      ),
      VocabularyWord(
        word: '飲む',
        reading: 'のむ',
        meaning: 'Uống',
        example: '水を飲みます。',
        exampleReading: 'みずをのみます。',
        exampleMeaning: 'Tôi uống nước.',
      ),
      // Add more mock words here
    ];
  }

  Widget _buildWordCard(VocabularyWord word) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    word.word,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.reading,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.meaning,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.example,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.exampleReading,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.exampleMeaning,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final words = _getWords();

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
                          'Danh sách từ vựng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Học các từ vựng dưới đây và nhấn "Luyện tập" để kiểm tra',
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
              itemCount: words.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildWordCard(words[index]),
            ),
          ],
        ),
      ),
    );
  }
} 