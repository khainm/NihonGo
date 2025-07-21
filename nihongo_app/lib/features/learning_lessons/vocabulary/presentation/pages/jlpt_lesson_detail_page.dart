import 'package:flutter/material.dart';
import '../../domain/entities/jlpt_vocabulary.dart';
import '../../data/datasources/jlpt_vocabulary_data_repository.dart';
import '../../data/services/jlpt_vocabulary_api_service.dart';
import '../../data/services/jlpt_progress_service.dart';
import '../widgets/jlpt_vocabulary_word_card.dart';

class JlptLessonDetailPage extends StatefulWidget {
  final String level;
  final int lessonNumber;
  final Color color;

  const JlptLessonDetailPage({
    super.key,
    required this.level,
    required this.lessonNumber,
    required this.color,
  });

  @override
  State<JlptLessonDetailPage> createState() => _JlptLessonDetailPageState();
}

class _JlptLessonDetailPageState extends State<JlptLessonDetailPage> {
  List<JlptVocabularyWord> words = []; // Initialize as empty list instead of late
  bool isStudyMode = true; // true = study mode, false = review mode
  bool isLoading = true;
  String? errorMessage;
  final JlptVocabularyApiService _apiService = JlptVocabularyApiService();
  final JlptProgressService _progressService = JlptProgressService();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Try to load from API first (with user progress)
      final lesson = await _apiService.getLessonWithProgress(
        jlptLevel: widget.level,
        lessonNumber: widget.lessonNumber,
      );

      if (lesson != null && lesson.vocabulary.isNotEmpty) {
        setState(() {
          words = lesson.vocabulary;
          isLoading = false;
        });
      } else {
        // Fallback to static data if API fails
        final repository = JlptVocabularyDataRepository();
        final loadedWords = await repository.getVocabularyByLevelAndLesson(
          widget.level,
          widget.lessonNumber,
        );

        setState(() {
          words = loadedWords;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi tải từ vựng: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _markWordAsLearned(String wordId) async {
    // Update local state first
    setState(() {
      final wordIndex = words.indexWhere((w) => w.id == wordId);
      if (wordIndex != -1) {
        words[wordIndex] = words[wordIndex].copyWith(isLearned: true);
      }
    });

    // Save progress to backend
    try {
      await _progressService.updateWordProgress(
        jlptLevel: widget.level,
        lessonId: 'bai_${widget.lessonNumber}',
        wordId: wordId,
        isLearned: true,
      );
      print('✅ Progress saved successfully for word: $wordId');
    } catch (e) {
      print('❌ Error saving progress for word $wordId: $e');
      // Show snackbar to inform user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lưu tiến độ: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Thử lại',
              textColor: Colors.white,
              onPressed: () => _markWordAsLearned(wordId),
            ),
          ),
        );
      }
    }
  }

  void _toggleMode() {
    setState(() {
      isStudyMode = !isStudyMode;
    });
  }

  List<JlptVocabularyWord> get _filteredWords {
    if (words.isEmpty) return [];
    
    if (isStudyMode) {
      return words.where((word) => !word.isLearned).toList();
    } else {
      return words.where((word) => word.isLearned).toList();
    }
  }

  void _goToPractice() {
    if (words.isEmpty) return;
    
    Navigator.pushNamed(
      context,
      '/jlpt-vocabulary/practice',
      arguments: {
        'jlptLevel': widget.level,
        'lessonNumber': widget.lessonNumber,
        'words': words.where((word) => word.isLearned).toList(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe access to words
    final filteredWords = _filteredWords;
    final learnedCount = words.isEmpty ? 0 : words.where((word) => word.isLearned).length;
    final totalCount = words.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài ${widget.lessonNumber} - ${widget.level}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            if (!isLoading)
              Text(
                isStudyMode 
                    ? 'Chế độ học (${totalCount - learnedCount}/${totalCount} từ)'
                    : 'Chế độ ôn tập (${learnedCount}/${totalCount} từ)',
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
          if (!isLoading && words.isNotEmpty)
            IconButton(
              icon: Icon(
                isStudyMode ? Icons.visibility : Icons.school,
                color: widget.color,
              ),
              onPressed: _toggleMode,
              tooltip: isStudyMode ? 'Chuyển sang ôn tập' : 'Chuyển sang học',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWords,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Progress bar
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tiến độ học tập',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '$learnedCount/$totalCount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: totalCount > 0 ? learnedCount / totalCount : 0,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tab bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!isStudyMode) _toggleMode();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isStudyMode ? widget.color : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Học mới (${totalCount - learnedCount})',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isStudyMode ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isStudyMode) _toggleMode();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isStudyMode ? widget.color : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Ôn tập (${learnedCount})',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isStudyMode ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Word list
                    Expanded(
                      child: filteredWords.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isStudyMode ? Icons.check_circle : Icons.school,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isStudyMode 
                                        ? 'Chúc mừng! Bạn đã học hết tất cả từ vựng'
                                        : 'Chưa có từ nào để ôn tập',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (isStudyMode && learnedCount > 0) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _goToPractice,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: widget.color,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text('Luyện tập'),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredWords.length,
                              itemBuilder: (context, index) {
                                final word = filteredWords[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: JlptVocabularyWordCard(
                                    word: word,
                                    color: widget.color,
                                    onMarkAsLearned: () => _markWordAsLearned(word.id),
                                    showLearnedButton: isStudyMode && !word.isLearned,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: !isLoading && 
                             learnedCount > 0 && 
                             filteredWords.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _goToPractice,
              backgroundColor: widget.color,
              icon: const Icon(Icons.quiz, color: Colors.white),
              label: const Text(
                'Luyện tập',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

// Placeholder for practice page - will be implemented later
class JlptVocabularyPracticePageOld extends StatelessWidget {
  final List<JlptVocabularyWord> words;
  final String level;
  final int lessonNumber;
  final Color color;

  const JlptVocabularyPracticePageOld({
    super.key,
    required this.words,
    required this.level,
    required this.lessonNumber,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luyện tập - Bài $lessonNumber ($level)'),
      ),
      body: const Center(
        child: Text(
          'Trang luyện tập sẽ được triển khai sau',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
