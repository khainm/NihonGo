import 'package:flutter/material.dart';
import '../../domain/entities/vocabulary_lesson.dart';

class VocabularyWordCard extends StatelessWidget {
  final VocabularyWord word;
  final Color color;
  final VoidCallback? onMarkAsLearned;
  final bool showAnswer;

  const VocabularyWordCard({
    super.key,
    required this.word,
    required this.color,
    this.onMarkAsLearned,
    this.showAnswer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
                // Japanese word
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        word.word,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (word.reading != word.word) ...[
                        const SizedBox(height: 4),
                        Text(
                          word.reading,
                          style: TextStyle(
                            fontSize: 14,
                            color: color.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Meaning and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showAnswer) ...[
                        Text(
                          word.meaning,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (word.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          children: word.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          Icon(
                            word.isLearned 
                                ? Icons.check_circle 
                                : Icons.radio_button_unchecked,
                            color: word.isLearned 
                                ? Colors.green 
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            word.isLearned ? 'Đã học' : 'Chưa học',
                            style: TextStyle(
                              fontSize: 14,
                              color: word.isLearned 
                                  ? Colors.green 
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onMarkAsLearned != null && !word.isLearned)
                  IconButton(
                    onPressed: onMarkAsLearned,
                    icon: Icon(
                      Icons.check,
                      color: color,
                    ),
                    tooltip: 'Đánh dấu đã học',
                  ),
              ],
            ),
            if (showAnswer && word.example.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Ví dụ:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                word.example,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                word.exampleTranslation,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
