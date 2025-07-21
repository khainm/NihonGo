import 'package:flutter/material.dart';
import '../../domain/entities/jlpt_vocabulary.dart';
import '../widgets/vocabulary_flashcard.dart';
import '../../data/services/jlpt_progress_service.dart';

class JlptVocabularyFlashcardPage extends StatefulWidget {
  final String jlptLevel;
  final int lessonNumber;
  final List<JlptVocabularyWord> words;

  const JlptVocabularyFlashcardPage({
    super.key,
    required this.jlptLevel,
    required this.lessonNumber,
    required this.words,
  });

  @override
  State<JlptVocabularyFlashcardPage> createState() => _JlptVocabularyFlashcardPageState();
}

class _JlptVocabularyFlashcardPageState extends State<JlptVocabularyFlashcardPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showBack = false;
  List<bool> _learnedStatus = [];
  final JlptProgressService _progressService = JlptProgressService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _learnedStatus = List.generate(widget.words.length, (index) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Flashcard ${widget.jlptLevel} - Bài ${widget.lessonNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getLevelColor(),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _shuffleCards,
            tooltip: 'Xáo trộn',
          ),
        ],
      ),
      body: widget.words.isEmpty
          ? const Center(
              child: Text(
                'Không có từ vựng để luyện tập',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Progress Indicator
                _buildProgressIndicator(),
                
                // Flashcard
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.words.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        _showBack = false;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: VocabularyFlashcard(
                          word: widget.words[index],
                          showBack: _showBack,
                          onTap: () {
                            setState(() {
                              _showBack = !_showBack;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                // Controls
                _buildControls(),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${widget.words.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Đã học: ${_learnedStatus.where((learned) => learned).length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: widget.words.isNotEmpty ? (_currentIndex + 1) / widget.words.length : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getLevelColor()),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Flip Card Button
          if (!_showBack)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showBack = true;
                  });
                },
                icon: const Icon(Icons.flip_to_back),
                label: const Text('Xem đáp án'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getLevelColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          
          // Learning Status Buttons
          if (_showBack) ...[
            const Text(
              'Bạn có nhớ từ này không?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsLearned(false),
                    icon: const Icon(Icons.close),
                    label: const Text('Chưa nhớ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsLearned(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Đã nhớ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _currentIndex > 0 ? _previousCard : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Trước'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _currentIndex < widget.words.length - 1 ? _nextCard : _finishPractice,
                  icon: Icon(_currentIndex < widget.words.length - 1 ? Icons.arrow_forward : Icons.check),
                  label: Text(_currentIndex < widget.words.length - 1 ? 'Tiếp' : 'Hoàn thành'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _markAsLearned(bool learned) {
    setState(() {
      _learnedStatus[_currentIndex] = learned;
    });
    
    // Save progress to backend
    _saveProgress(learned);
    
    // Auto navigate to next card after marking
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentIndex < widget.words.length - 1) {
        _nextCard();
      } else {
        _finishPractice();
      }
    });
  }

  Future<void> _saveProgress(bool isLearned) async {
    try {
      final currentWord = widget.words[_currentIndex];
      await _progressService.updateWordProgress(
        jlptLevel: widget.jlptLevel,
        lessonId: 'bai_${widget.lessonNumber}',
        wordId: currentWord.id,
        isLearned: isLearned,
      );
    } catch (e) {
      // Silent fail - we don't want to interrupt the user experience
      print('Failed to save progress: $e');
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextCard() {
    if (_currentIndex < widget.words.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _shuffleCards() {
    setState(() {
      widget.words.shuffle();
      _learnedStatus = List.generate(widget.words.length, (index) => false);
      _currentIndex = 0;
      _showBack = false;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishPractice() {
    final learnedCount = _learnedStatus.where((learned) => learned).length;
    final accuracy = learnedCount / widget.words.length;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Hoàn thành luyện tập!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              accuracy >= 0.8 ? Icons.emoji_events : Icons.thumb_up,
              size: 64,
              color: accuracy >= 0.8 ? Colors.amber : Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'Kết quả: $learnedCount/${widget.words.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Độ chính xác: ${(accuracy * 100).toInt()}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to practice page
            },
            child: const Text('Hoàn thành'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _restartPractice();
            },
            child: const Text('Luyện lại'),
          ),
        ],
      ),
    );
  }

  void _restartPractice() {
    setState(() {
      _learnedStatus = List.generate(widget.words.length, (index) => false);
      _currentIndex = 0;
      _showBack = false;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color _getLevelColor() {
    switch (widget.jlptLevel) {
      case 'N5':
        return Colors.green;
      case 'N4':
        return Colors.blue;
      case 'N3':
        return Colors.orange;
      case 'N2':
        return Colors.red;
      case 'N1':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
