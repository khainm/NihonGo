import 'package:flutter/material.dart';
import '../../domain/entities/grammar_lesson.dart';

enum GrammarPracticeType {
  patternMatching,      // Kết hợp mẫu câu với nghĩa
  sentenceCompletion,   // Hoàn thành câu
  errorCorrection,      // Sửa lỗi ngữ pháp
  translateToJapanese,  // Dịch sang tiếng Nhật
}

class GrammarPracticePage extends StatefulWidget {
  final GrammarLesson lesson;
  final Color color;

  const GrammarPracticePage({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<GrammarPracticePage> createState() => _GrammarPracticePageState();
}

class _GrammarPracticePageState extends State<GrammarPracticePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  GrammarPracticeType currentPracticeType = GrammarPracticeType.patternMatching;
  List<GrammarPoint> practiceGrammarPoints = [];
  int currentQuestionIndex = 0;
  bool showAnswer = false;
  int correctAnswers = 0;
  int totalAttempts = 0;
  
  // Pattern matching variables
  List<String> choices = [];
  int? selectedChoiceIndex;
  bool hasAnswered = false;
  
  // Sentence completion variables
  String userInput = '';
  final TextEditingController _textController = TextEditingController();
  
  // Error correction variables
  String incorrectSentence = '';
  String correctSentence = '';
  List<String> errorOptions = [];
  int? selectedErrorIndex;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializePractice();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  void _initializePractice() {
    setState(() {
      practiceGrammarPoints = List.from(widget.lesson.grammarPoints)..shuffle();
      currentQuestionIndex = 0;
      showAnswer = false;
      correctAnswers = 0;
      totalAttempts = 0;
    });
    _generateQuestion();
  }

  void _generateQuestion() {
    if (currentQuestionIndex >= practiceGrammarPoints.length) return;
    
    switch (currentPracticeType) {
      case GrammarPracticeType.patternMatching:
        _generatePatternMatchingChoices();
        break;
      case GrammarPracticeType.sentenceCompletion:
        _generateSentenceCompletion();
        break;
      case GrammarPracticeType.errorCorrection:
        _generateErrorCorrection();
        break;
      case GrammarPracticeType.translateToJapanese:
        _generateTranslationChoices();
        break;
    }
    
    setState(() {
      selectedChoiceIndex = null;
      selectedErrorIndex = null;
      hasAnswered = false;
      userInput = '';
      _textController.clear();
    });
  }

  void _generatePatternMatchingChoices() {
    final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
    
    choices = [currentGrammar.meaning];
    
    // Add wrong choices from other grammar points
    final otherGrammars = widget.lesson.grammarPoints
        .where((g) => g.id != currentGrammar.id)
        .toList()..shuffle();
    
    for (int i = 0; i < 3 && i < otherGrammars.length; i++) {
      choices.add(otherGrammars[i].meaning);
    }
    
    choices.shuffle();
  }

  void _generateSentenceCompletion() {
    final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
    if (currentGrammar.examples.isNotEmpty) {
      final example = currentGrammar.examples.first;
      incorrectSentence = example.japanese.replaceAll(currentGrammar.pattern, '___');
    }
  }

  void _generateErrorCorrection() {
    final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
    if (currentGrammar.examples.isNotEmpty) {
      final example = currentGrammar.examples.first;
      correctSentence = example.japanese;
      
      // Create an incorrect version by replacing the pattern
      final wrongPatterns = widget.lesson.grammarPoints
          .where((g) => g.id != currentGrammar.id)
          .map((g) => g.pattern)
          .take(3)
          .toList();
      
      if (wrongPatterns.isNotEmpty) {
        incorrectSentence = example.japanese.replaceAll(
          currentGrammar.pattern, 
          wrongPatterns.first
        );
        
        errorOptions = [
          currentGrammar.pattern,
          ...wrongPatterns.take(3),
        ]..shuffle();
      }
    }
  }

  void _generateTranslationChoices() {
    final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
    if (currentGrammar.examples.isNotEmpty) {
      final example = currentGrammar.examples.first;
      choices = [example.japanese];
      
      // Add wrong choices from other examples
      final otherExamples = widget.lesson.grammarPoints
          .expand((g) => g.examples)
          .where((e) => e.id != example.id)
          .toList()..shuffle();
      
      for (int i = 0; i < 3 && i < otherExamples.length; i++) {
        choices.add(otherExamples[i].japanese);
      }
      
      choices.shuffle();
    }
  }

  void _checkAnswer() {
    setState(() {
      hasAnswered = true;
      totalAttempts++;
      
      bool isCorrect = false;
      final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
      
      switch (currentPracticeType) {
        case GrammarPracticeType.patternMatching:
          if (selectedChoiceIndex != null) {
            isCorrect = choices[selectedChoiceIndex!] == currentGrammar.meaning;
          }
          break;
        case GrammarPracticeType.sentenceCompletion:
          isCorrect = userInput.trim().toLowerCase() == currentGrammar.pattern.toLowerCase();
          break;
        case GrammarPracticeType.errorCorrection:
          if (selectedErrorIndex != null) {
            isCorrect = errorOptions[selectedErrorIndex!] == currentGrammar.pattern;
          }
          break;
        case GrammarPracticeType.translateToJapanese:
          if (selectedChoiceIndex != null && currentGrammar.examples.isNotEmpty) {
            isCorrect = choices[selectedChoiceIndex!] == currentGrammar.examples.first.japanese;
          }
          break;
      }
      
      if (isCorrect) {
        correctAnswers++;
      }
    });
    
    // Auto advance after delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    _animationController.reset();
    setState(() {
      if (currentQuestionIndex < practiceGrammarPoints.length - 1) {
        currentQuestionIndex++;
        _generateQuestion();
      } else {
        _showResultDialog();
      }
    });
    _animationController.forward();
  }

  void _showResultDialog() {
    final percentage = totalAttempts > 0 ? (correctAnswers / totalAttempts * 100).round() : 0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              percentage >= 80 ? Icons.celebration : Icons.thumb_up,
              color: widget.color,
            ),
            const SizedBox(width: 8),
            const Text('Kết quả luyện tập'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$correctAnswers/$totalAttempts câu đúng',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 80
                  ? 'Xuất sắc! Bạn đã nắm vững ngữ pháp này.'
                  : percentage >= 60
                      ? 'Tốt! Hãy tiếp tục luyện tập để cải thiện.'
                      : 'Cần cố gắng thêm! Hãy xem lại lý thuyết nhé.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Kết thúc'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializePractice();
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.color),
            child: const Text('Luyện lại', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (practiceGrammarPoints.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Luyện tập ngữ pháp'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Không có ngữ pháp để luyện tập'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Luyện tập: ${widget.lesson.title}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<GrammarPracticeType>(
            icon: Icon(Icons.more_vert, color: widget.color),
            onSelected: (type) {
              setState(() {
                currentPracticeType = type;
                _initializePractice();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: GrammarPracticeType.patternMatching,
                child: Row(
                  children: [
                    Icon(Icons.quiz),
                    SizedBox(width: 8),
                    Text('Kết hợp mẫu câu'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: GrammarPracticeType.sentenceCompletion,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Hoàn thành câu'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: GrammarPracticeType.errorCorrection,
                child: Row(
                  children: [
                    Icon(Icons.error_outline),
                    SizedBox(width: 8),
                    Text('Sửa lỗi'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: GrammarPracticeType.translateToJapanese,
                child: Row(
                  children: [
                    Icon(Icons.translate),
                    SizedBox(width: 8),
                    Text('Dịch sang Nhật'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getPracticeTypeTitle(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      '${currentQuestionIndex + 1}/${practiceGrammarPoints.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / practiceGrammarPoints.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          
          // Practice content
          Expanded(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _slideAnimation.value)),
                    child: _buildPracticeContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getPracticeTypeTitle() {
    switch (currentPracticeType) {
      case GrammarPracticeType.patternMatching:
        return 'Kết hợp mẫu câu';
      case GrammarPracticeType.sentenceCompletion:
        return 'Hoàn thành câu';
      case GrammarPracticeType.errorCorrection:
        return 'Sửa lỗi ngữ pháp';
      case GrammarPracticeType.translateToJapanese:
        return 'Dịch sang tiếng Nhật';
    }
  }

  Widget _buildPracticeContent() {
    final currentGrammar = practiceGrammarPoints[currentQuestionIndex];
    
    switch (currentPracticeType) {
      case GrammarPracticeType.patternMatching:
        return _buildPatternMatchingContent(currentGrammar);
      case GrammarPracticeType.sentenceCompletion:
        return _buildSentenceCompletionContent(currentGrammar);
      case GrammarPracticeType.errorCorrection:
        return _buildErrorCorrectionContent(currentGrammar);
      case GrammarPracticeType.translateToJapanese:
        return _buildTranslationContent(currentGrammar);
    }
  }

  Widget _buildPatternMatchingContent(GrammarPoint grammar) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Mẫu câu này có nghĩa là gì?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          grammar.pattern,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cách sử dụng: ${grammar.usage}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...choices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final choice = entry.value;
                  
                  Color? buttonColor;
                  if (hasAnswered) {
                    if (choice == grammar.meaning) {
                      buttonColor = Colors.green;
                    } else if (selectedChoiceIndex == index) {
                      buttonColor = Colors.red;
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: hasAnswered ? null : () {
                          setState(() {
                            selectedChoiceIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor ?? 
                              (selectedChoiceIndex == index ? widget.color : Colors.white),
                          foregroundColor: buttonColor != null || selectedChoiceIndex == index 
                              ? Colors.white 
                              : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: buttonColor ?? widget.color.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          choice,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (hasAnswered && grammar.examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ví dụ:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          grammar.examples.first.japanese,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          grammar.examples.first.translation,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selectedChoiceIndex != null && !hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Xác nhận'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSentenceCompletionContent(GrammarPoint grammar) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Điền từ thích hợp vào chỗ trống:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          incorrectSentence,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (grammar.examples.isNotEmpty)
                        Text(
                          'Nghĩa: ${grammar.examples.first.translation}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _textController,
                  enabled: !hasAnswered,
                  onChanged: (value) => setState(() => userInput = value),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ ngữ pháp...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.color),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: widget.color, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                ),
                if (hasAnswered) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                                  ? 'Chính xác!'
                                  : 'Sai rồi!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: userInput.trim().toLowerCase() == grammar.pattern.toLowerCase()
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        if (userInput.trim().toLowerCase() != grammar.pattern.toLowerCase()) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Đáp án đúng: ${grammar.pattern}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nghĩa: ${grammar.meaning}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (userInput.isNotEmpty && !hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kiểm tra'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorCorrectionContent(GrammarPoint grammar) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Câu này có lỗi ngữ pháp. Chọn từ đúng:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Câu sai:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              incorrectSentence,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chọn từ ngữ pháp đúng:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...errorOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  
                  Color? buttonColor;
                  if (hasAnswered) {
                    if (option == grammar.pattern) {
                      buttonColor = Colors.green;
                    } else if (selectedErrorIndex == index) {
                      buttonColor = Colors.red;
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: hasAnswered ? null : () {
                          setState(() {
                            selectedErrorIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor ?? 
                              (selectedErrorIndex == index ? widget.color : Colors.white),
                          foregroundColor: buttonColor != null || selectedErrorIndex == index 
                              ? Colors.white 
                              : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: buttonColor ?? widget.color.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (hasAnswered) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Câu đúng:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          correctSentence,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selectedErrorIndex != null && !hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Xác nhận'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTranslationContent(GrammarPoint grammar) {
    if (grammar.examples.isEmpty) {
      return const Center(child: Text('Không có ví dụ để luyện tập'));
    }

    final example = grammar.examples.first;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Dịch câu này sang tiếng Nhật:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          example.translation,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Gợi ý: Sử dụng mẫu câu "${grammar.pattern}"',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...choices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final choice = entry.value;
                  
                  Color? buttonColor;
                  if (hasAnswered) {
                    if (choice == example.japanese) {
                      buttonColor = Colors.green;
                    } else if (selectedChoiceIndex == index) {
                      buttonColor = Colors.red;
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: hasAnswered ? null : () {
                          setState(() {
                            selectedChoiceIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor ?? 
                              (selectedChoiceIndex == index ? widget.color : Colors.white),
                          foregroundColor: buttonColor != null || selectedChoiceIndex == index 
                              ? Colors.white 
                              : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: buttonColor ?? widget.color.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          choice,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (hasAnswered) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giải thích:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          grammar.explanation,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selectedChoiceIndex != null && !hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Xác nhận'),
              ),
            ),
        ],
      ),
    );
  }
}
