import 'package:flutter/material.dart';
import '../../domain/entities/kanji_lesson.dart';

class KanjiQuizCard extends StatefulWidget {
  final KanjiLesson lesson;
  final Color color;

  const KanjiQuizCard({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<KanjiQuizCard> createState() => _KanjiQuizCardState();
}

class _KanjiQuizCardState extends State<KanjiQuizCard> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  int _score = 0;
  
  // Mock quiz data
  final List<Map<String, dynamic>> quizData = [
    {
      'question': 'Kanji nào có nghĩa là "người"?',
      'options': ['人', '日', '本', '学'],
      'correctAnswer': 0,
      'explanation': '人 (ひと/ジン/ニン) có nghĩa là người',
    },
    {
      'question': 'Âm đọc Kun của kanji 日 là gì?',
      'options': ['にち', 'ひ', 'じつ', 'か'],
      'correctAnswer': 1,
      'explanation': '日 có âm Kun là ひ (hi) và か (ka)',
    },
    {
      'question': 'Kanji 本 có bao nhiều nét?',
      'options': ['4 nét', '5 nét', '6 nét', '7 nét'],
      'correctAnswer': 1,
      'explanation': 'Kanji 本 có 5 nét',
    },
    {
      'question': 'Kanji nào có nghĩa là "học"?',
      'options': ['学', '時', '人', '日'],
      'correctAnswer': 0,
      'explanation': '学 (がく/まな) có nghĩa là học',
    },
    {
      'question': 'Âm đọc On của kanji 時 là gì?',
      'options': ['とき', 'じ', 'ときめき', 'しじ'],
      'correctAnswer': 1,
      'explanation': '時 có âm On là ジ (ji)',
    },
  ];

  void _selectAnswer(int index) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    
    setState(() {
      _showResult = true;
      if (_selectedAnswer == quizData[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < quizData.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kết quả bài kiểm tra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _score >= quizData.length * 0.7 ? Icons.celebration : Icons.thumb_up,
              size: 64,
              color: _score >= quizData.length * 0.7 ? Colors.amber : widget.color,
            ),
            const SizedBox(height: 16),
            Text(
              'Điểm của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '$_score/${quizData.length}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${((_score / quizData.length) * 100).toInt()}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetQuiz();
            },
            child: const Text('Làm lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Kết thúc'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _showResult = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizData[_currentQuestionIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.quiz, color: widget.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trắc nghiệm Kanji',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      Text(
                        'Kiểm tra kiến thức của bạn',
                        style: TextStyle(
                          fontSize: 12,
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
          
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu ${_currentQuestionIndex + 1}/${quizData.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Điểm: $_score',
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
            value: (_currentQuestionIndex + 1) / quizData.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            minHeight: 6,
          ),
          
          const SizedBox(height: 32),
          
          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              currentQuestion['question'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          ...List.generate(
            currentQuestion['options'].length,
            (index) => _buildOptionCard(
              index,
              currentQuestion['options'][index],
              currentQuestion['correctAnswer'],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showResult ? _nextQuestion : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _showResult 
                  ? (_currentQuestionIndex < quizData.length - 1 ? 'Câu tiếp theo' : 'Xem kết quả')
                  : 'Trả lời',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Explanation
          if (_showResult) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Giải thích',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentQuestion['explanation'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String option, int correctAnswer) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == correctAnswer;
    final showResult = _showResult;
    
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black;
    
    if (showResult) {
      if (isCorrect) {
        cardColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green[700]!;
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red[700]!;
      }
    } else if (isSelected) {
      cardColor = widget.color.withOpacity(0.1);
      borderColor = widget.color;
      textColor = widget.color;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected || (showResult && isCorrect) ? borderColor : Colors.transparent,
                  border: Border.all(color: borderColor),
                ),
                child: isSelected || (showResult && isCorrect)
                  ? Icon(
                      showResult && isCorrect ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (showResult && isCorrect)
                Icon(Icons.check_circle, color: Colors.green, size: 20),
              if (showResult && isSelected && !isCorrect)
                Icon(Icons.cancel, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
