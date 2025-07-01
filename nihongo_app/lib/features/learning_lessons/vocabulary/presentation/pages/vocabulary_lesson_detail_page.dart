import 'package:flutter/material.dart';
import '../../domain/entities/vocabulary_lesson.dart';
import '../widgets/vocabulary_word_card.dart';

class VocabularyLessonDetailPage extends StatefulWidget {
  final VocabularyLesson lesson;
  final Color color;

  const VocabularyLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<VocabularyLessonDetailPage> createState() => _VocabularyLessonDetailPageState();
}

class _VocabularyLessonDetailPageState extends State<VocabularyLessonDetailPage> {
  late List<VocabularyWord> words;
  bool isStudyMode = true; // true = study mode, false = review mode

  @override
  void initState() {
    super.initState();
    words = List.from(widget.lesson.words);
  }

  void _markWordAsLearned(int wordId) {
    setState(() {
      final wordIndex = words.indexWhere((w) => w.id == wordId);
      if (wordIndex != -1) {
        words[wordIndex] = VocabularyWord(
          id: words[wordIndex].id,
          word: words[wordIndex].word,
          reading: words[wordIndex].reading,
          meaning: words[wordIndex].meaning,
          example: words[wordIndex].example,
          exampleTranslation: words[wordIndex].exampleTranslation,
          tags: words[wordIndex].tags,
          isLearned: true,
        );
      }
    });
  }

  void _toggleMode() {
    setState(() {
      isStudyMode = !isStudyMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final learnedWords = words.where((w) => w.isLearned).length;
    final progress = words.isNotEmpty ? learnedWords / words.length : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.lesson.description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
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
            onPressed: _toggleMode,
            icon: Icon(
              isStudyMode ? Icons.quiz : Icons.school,
              color: widget.color,
            ),
            tooltip: isStudyMode ? 'Chế độ ôn tập' : 'Chế độ học',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_stories, color: widget.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isStudyMode ? 'Đang học từ vựng' : 'Ôn tập từ vựng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isStudyMode 
                                  ? 'Học từng từ một cách chi tiết'
                                  : 'Ôn tập lại các từ đã học',
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tiến độ học',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '$learnedWords/${words.length}',
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
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Mode indicator
            Row(
              children: [
                Icon(
                  isStudyMode ? Icons.school : Icons.quiz,
                  color: widget.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isStudyMode ? 'Chế độ học' : 'Chế độ ôn tập',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Text(
                  '${words.length} từ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Words list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: words.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final word = words[index];
                
                // In review mode, only show learned words
                if (!isStudyMode && !word.isLearned) {
                  return const SizedBox.shrink();
                }
                
                return VocabularyWordCard(
                  word: word,
                  color: widget.color,
                  showAnswer: isStudyMode,
                  onMarkAsLearned: isStudyMode && !word.isLearned
                      ? () => _markWordAsLearned(word.id)
                      : null,
                );
              },
            ),
            const SizedBox(height: 32),
            
            // Action buttons
            if (isStudyMode) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: learnedWords == words.length 
                      ? () => _toggleMode()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.quiz),
                  label: const Text(
                    'Bắt đầu ôn tập',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _toggleMode(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.color,
                        side: BorderSide(color: widget.color),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.school),
                      label: const Text('Học lại'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to practice/quiz
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tính năng luyện tập sẽ được thêm sau!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.psychology),
                      label: const Text('Luyện tập'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
