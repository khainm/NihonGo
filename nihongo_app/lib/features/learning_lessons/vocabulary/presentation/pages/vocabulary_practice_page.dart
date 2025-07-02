import 'package:flutter/material.dart';
import '../../domain/entities/vocabulary_lesson.dart';

enum PracticeType {
  flashcard,
  multipleChoice,
  fillInTheBlank,
}

class VocabularyPracticePage extends StatefulWidget {
  final VocabularyLesson lesson;
  final Color color;

  const VocabularyPracticePage({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<VocabularyPracticePage> createState() => _VocabularyPracticePageState();
}

class _VocabularyPracticePageState extends State<VocabularyPracticePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  PracticeType currentPracticeType = PracticeType.flashcard;
  List<VocabularyWord> practiceWords = [];
  int currentWordIndex = 0;
  bool showAnswer = false;
  int correctAnswers = 0;
  int totalAttempts = 0;
  
  // Multiple choice variables
  List<String> choices = [];
  int? selectedChoiceIndex;
  bool hasAnswered = false;
  
  // Fill in the blank variables
  String userInput = '';
  final TextEditingController _textController = TextEditingController();

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
      practiceWords = List.from(widget.lesson.words)..shuffle();
      currentWordIndex = 0;
      showAnswer = false;
      correctAnswers = 0;
      totalAttempts = 0;
    });
    _generateChoices();
  }

  void _generateChoices() {
    if (currentWordIndex >= practiceWords.length) return;
    
    final currentWord = practiceWords[currentWordIndex];
    
    // Get other words for wrong choices
    final otherWords = widget.lesson.words
        .where((w) => w.id != currentWord.id)
        .toList()..shuffle();
    
    choices = [currentWord.meaning];
    
    // Add 3 wrong choices
    for (int i = 0; i < 3 && i < otherWords.length; i++) {
      choices.add(otherWords[i].meaning);
    }
    
    choices.shuffle();
    selectedChoiceIndex = null;
    hasAnswered = false;
  }

  void _nextWord() {
    _animationController.reset();
    setState(() {
      if (currentWordIndex < practiceWords.length - 1) {
        currentWordIndex++;
        showAnswer = false;
        userInput = '';
        _textController.clear();
        _generateChoices();
      } else {
        _showResultDialog();
      }
    });
    _animationController.forward();
  }

  void _checkMultipleChoiceAnswer() {
    if (selectedChoiceIndex == null) return;
    
    setState(() {
      hasAnswered = true;
      totalAttempts++;
      
      final currentWord = practiceWords[currentWordIndex];
      if (choices[selectedChoiceIndex!] == currentWord.meaning) {
        correctAnswers++;
      }
    });
    
    // Auto advance after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _nextWord();
    });
  }

  void _checkFillInTheBlankAnswer() {
    setState(() {
      hasAnswered = true;
      totalAttempts++;
      
      final currentWord = practiceWords[currentWordIndex];
      final userAnswer = userInput.trim().toLowerCase();
      final correctAnswer = currentWord.word.toLowerCase();
      
      if (userAnswer == correctAnswer) {
        correctAnswers++;
      }
    });
    
    // Auto advance after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) _nextWord();
    });
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
                  ? 'Xuất sắc! Bạn đã thành thạo các từ vựng này.'
                  : percentage >= 60
                      ? 'Tốt! Hãy tiếp tục luyện tập để cải thiện.'
                      : 'Cần cố gắng thêm! Đừng bỏ cuộc nhé.',
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
    if (practiceWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Luyện tập từ vựng'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Không có từ vựng để luyện tập'),
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
          PopupMenuButton<PracticeType>(
            icon: Icon(Icons.more_vert, color: widget.color),
            onSelected: (type) {
              setState(() {
                currentPracticeType = type;
                _initializePractice();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: PracticeType.flashcard,
                child: Row(
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(width: 8),
                    Text('Flashcard'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: PracticeType.multipleChoice,
                child: Row(
                  children: [
                    Icon(Icons.quiz),
                    SizedBox(width: 8),
                    Text('Trắc nghiệm'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: PracticeType.fillInTheBlank,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Điền từ'),
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
                      '${currentWordIndex + 1}/${practiceWords.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentWordIndex + 1) / practiceWords.length,
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
      case PracticeType.flashcard:
        return 'Flashcard';
      case PracticeType.multipleChoice:
        return 'Trắc nghiệm';
      case PracticeType.fillInTheBlank:
        return 'Điền từ';
    }
  }

  Widget _buildPracticeContent() {
    final currentWord = practiceWords[currentWordIndex];
    
    switch (currentPracticeType) {
      case PracticeType.flashcard:
        return _buildFlashcardContent(currentWord);
      case PracticeType.multipleChoice:
        return _buildMultipleChoiceContent(currentWord);
      case PracticeType.fillInTheBlank:
        return _buildFillInTheBlankContent(currentWord);
    }
  }

  Widget _buildFlashcardContent(VocabularyWord word) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => showAnswer = !showAnswer),
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!showAnswer) ...[
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          word.reading,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        Text(
                          word.meaning,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                word.example,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                word.exampleTranslation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => showAnswer = !showAnswer),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.color,
                    side: BorderSide(color: widget.color),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(showAnswer ? 'Ẩn đáp án' : 'Hiện đáp án'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(currentWordIndex < practiceWords.length - 1 ? 'Tiếp theo' : 'Hoàn thành'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceContent(VocabularyWord word) {
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
                        'Từ này có nghĩa là gì?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        word.word,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        word.reading,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
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
                    if (choice == word.meaning) {
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
              ],
            ),
          ),
          if (selectedChoiceIndex != null && !hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkMultipleChoiceAnswer,
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

  Widget _buildFillInTheBlankContent(VocabularyWord word) {
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
                        'Nhập từ tiếng Nhật có nghĩa:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        word.meaning,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đọc: ${word.reading}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ tiếng Nhật...',
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
                      color: userInput.trim().toLowerCase() == word.word.toLowerCase()
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: userInput.trim().toLowerCase() == word.word.toLowerCase()
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              userInput.trim().toLowerCase() == word.word.toLowerCase()
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: userInput.trim().toLowerCase() == word.word.toLowerCase()
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              userInput.trim().toLowerCase() == word.word.toLowerCase()
                                  ? 'Chính xác!'
                                  : 'Sai rồi!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: userInput.trim().toLowerCase() == word.word.toLowerCase()
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        if (userInput.trim().toLowerCase() != word.word.toLowerCase()) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Đáp án đúng: ${word.word}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                onPressed: _checkFillInTheBlankAnswer,
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
}
