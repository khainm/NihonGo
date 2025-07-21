import 'package:flutter/material.dart';
import '../../domain/entities/jlpt_vocabulary.dart';
import '../../data/services/jlpt_progress_service.dart';

class JlptVocabularyQuizPage extends StatefulWidget {
  final String jlptLevel;
  final int lessonNumber;
  final List<JlptVocabularyWord> words;

  const JlptVocabularyQuizPage({
    super.key,
    required this.jlptLevel,
    required this.lessonNumber,
    required this.words,
  });

  @override
  State<JlptVocabularyQuizPage> createState() => _JlptVocabularyQuizPageState();
}

class _JlptVocabularyQuizPageState extends State<JlptVocabularyQuizPage>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int? selectedAnswerIndex;
  bool showAnswer = false;
  late List<JlptVocabularyWord> shuffledWords;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final JlptProgressService _progressService = JlptProgressService();

  @override
  void initState() {
    super.initState();
    shuffledWords = List.from(widget.words)..shuffle();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> _generateAnswerOptions(JlptVocabularyWord correctWord) {
    final allWords = widget.words.where((w) => w != correctWord).toList();
    allWords.shuffle();
    
    final options = [
      correctWord.vietnamese,
      ...allWords.take(3).map((w) => w.vietnamese),
    ];
    options.shuffle();
    return options;
  }

  void _selectAnswer(int index) {
    if (showAnswer) return;
    
    setState(() {
      selectedAnswerIndex = index;
      showAnswer = true;
    });

    final currentWord = shuffledWords[currentQuestionIndex];
    final isCorrect = _generateAnswerOptions(currentWord)[index] == currentWord.vietnamese;
    
    if (isCorrect) {
      correctAnswers++;
    }

    // Save progress to backend
    _saveProgress(isCorrect);

    // Auto advance after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  Future<void> _saveProgress(bool isCorrect) async {
    try {
      final currentWord = shuffledWords[currentQuestionIndex];
      await _progressService.updateWordProgress(
        jlptLevel: widget.jlptLevel,
        lessonId: 'bai_${widget.lessonNumber}',
        wordId: currentWord.id,
        isLearned: isCorrect,
      );
    } catch (e) {
      // Silent fail
      print('Failed to save progress: $e');
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < shuffledWords.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showAnswer = false;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              correctAnswers >= shuffledWords.length * 0.7
                  ? Icons.celebration
                  : Icons.school,
              size: 64,
              color: correctAnswers >= shuffledWords.length * 0.7
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $correctAnswers / ${shuffledWords.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${((correctAnswers / shuffledWords.length) * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: correctAnswers >= shuffledWords.length * 0.7
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Practice'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                correctAnswers = 0;
                selectedAnswerIndex = null;
                showAnswer = false;
                shuffledWords.shuffle();
              });
              _animationController.reset();
              _animationController.forward();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (shuffledWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.jlptLevel} Quiz'),
        ),
        body: const Center(
          child: Text('No words available for quiz'),
        ),
      );
    }

    final currentWord = shuffledWords[currentQuestionIndex];
    final answerOptions = _generateAnswerOptions(currentWord);
    final progress = (currentQuestionIndex + 1) / shuffledWords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.jlptLevel} Quiz - Lesson ${widget.lessonNumber}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${currentQuestionIndex + 1}/${shuffledWords.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'What does this word mean?',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentWord.japanese,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                          if (currentWord.reading?.isNotEmpty == true) ...[
                            const SizedBox(height: 8),
                            Text(
                              currentWord.reading!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Answer options
                    Expanded(
                      child: ListView.builder(
                        itemCount: answerOptions.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedAnswerIndex == index;
                          final isCorrect = showAnswer && 
                              answerOptions[index] == currentWord.vietnamese;
                          final isWrong = showAnswer && isSelected && !isCorrect;

                          Color? backgroundColor;
                          Color? borderColor;
                          if (showAnswer) {
                            if (isCorrect) {
                              backgroundColor = Colors.green.withOpacity(0.1);
                              borderColor = Colors.green;
                            } else if (isWrong) {
                              backgroundColor = Colors.red.withOpacity(0.1);
                              borderColor = Colors.red;
                            }
                          } else if (isSelected) {
                            backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
                            borderColor = Theme.of(context).primaryColor;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              child: InkWell(
                                onTap: () => _selectAnswer(index),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: borderColor ?? Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: borderColor?.withOpacity(0.2),
                                          border: Border.all(
                                            color: borderColor ?? Colors.grey[400]!,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            String.fromCharCode(65 + index), // A, B, C, D
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: borderColor ?? Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          answerOptions[index],
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: isSelected ? FontWeight.w600 : null,
                                          ),
                                        ),
                                      ),
                                      if (showAnswer && isCorrect)
                                        const Icon(Icons.check_circle, color: Colors.green),
                                      if (showAnswer && isWrong)
                                        const Icon(Icons.cancel, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
