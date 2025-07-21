import 'package:flutter/material.dart';
import '../../domain/entities/jlpt_vocabulary.dart';
import '../../data/datasources/jlpt_vocabulary_data_repository.dart';
import '../widgets/practice_mode_card.dart';
import '../widgets/practice_stats_card.dart';

class JlptVocabularyPracticePage extends StatefulWidget {
  final String jlptLevel;
  final int lessonNumber;

  const JlptVocabularyPracticePage({
    super.key,
    required this.jlptLevel,
    required this.lessonNumber,
  });

  @override
  State<JlptVocabularyPracticePage> createState() => _JlptVocabularyPracticePageState();
}

class _JlptVocabularyPracticePageState extends State<JlptVocabularyPracticePage> {
  final JlptVocabularyDataRepository _repository = JlptVocabularyDataRepository();
  List<JlptVocabularyWord> _words = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    try {
      final words = await _repository.getVocabularyByLevelAndLesson(
        widget.jlptLevel,
        widget.lessonNumber,
      );
      setState(() {
        _words = words;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải từ vựng: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Luyện tập ${widget.jlptLevel} - Bài ${widget.lessonNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getLevelColor(),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/vocabulary-debug');
            },
            icon: const Icon(Icons.bug_report),
            tooltip: 'Debug',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _words.isEmpty
              ? const Center(
                  child: Text(
                    'Không có từ vựng để luyện tập',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thống kê
          PracticeStatsCard(
            totalWords: _words.length,
            learnedWords: _words.where((w) => w.isLearned).length,
            accuracy: _calculateAccuracy(),
          ),
          const SizedBox(height: 20),
          
          // Tiêu đề chế độ luyện tập
          const Text(
            'Chọn chế độ luyện tập',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Các chế độ luyện tập
          _buildPracticeModes(),
        ],
      ),
    );
  }

  Widget _buildPracticeModes() {
    return Column(
      children: [
        // Flashcard Mode
        PracticeModeCard(
          title: 'Flashcard',
          description: 'Lật thẻ để học từ vựng',
          icon: Icons.flip_to_front,
          color: Colors.blue,
          onTap: () => _navigateToFlashcard(),
        ),
        const SizedBox(height: 12),
        
        // Quiz Mode
        PracticeModeCard(
          title: 'Trắc nghiệm',
          description: 'Chọn đáp án đúng',
          icon: Icons.quiz,
          color: Colors.green,
          onTap: () => _navigateToQuiz(),
        ),
        const SizedBox(height: 12),
        
        // Writing Mode
        PracticeModeCard(
          title: 'Viết từ',
          description: 'Viết từ tiếng Nhật',
          icon: Icons.edit,
          color: Colors.orange,
          onTap: () => _navigateToWriting(),
        ),
        const SizedBox(height: 12),
        
        // Listening Mode (future feature)
        PracticeModeCard(
          title: 'Nghe từ',
          description: 'Nghe và chọn từ đúng',
          icon: Icons.headphones,
          color: Colors.purple,
          onTap: () => _showComingSoon('Nghe từ'),
          enabled: false,
        ),
        const SizedBox(height: 12),
        
        // Mixed Mode
        PracticeModeCard(
          title: 'Tổng hợp',
          description: 'Kết hợp tất cả chế độ',
          icon: Icons.shuffle,
          color: Colors.red,
          onTap: () => _navigateToMixed(),
        ),
      ],
    );
  }

  void _navigateToFlashcard() {
    Navigator.pushNamed(
      context,
      '/jlpt-vocabulary/practice/flashcard',
      arguments: {
        'jlptLevel': widget.jlptLevel,
        'lessonNumber': widget.lessonNumber,
        'words': _words,
      },
    );
  }

  void _navigateToQuiz() {
    Navigator.pushNamed(
      context,
      '/jlpt-vocabulary/practice/quiz',
      arguments: {
        'jlptLevel': widget.jlptLevel,
        'lessonNumber': widget.lessonNumber,
        'words': _words,
      },
    );
  }

  void _navigateToWriting() {
    Navigator.pushNamed(
      context,
      '/jlpt-vocabulary/practice/writing',
      arguments: {
        'jlptLevel': widget.jlptLevel,
        'lessonNumber': widget.lessonNumber,
        'words': _words,
      },
    );
  }

  void _navigateToMixed() {
    Navigator.pushNamed(
      context,
      '/jlpt-vocabulary/practice/mixed',
      arguments: {
        'jlptLevel': widget.jlptLevel,
        'lessonNumber': widget.lessonNumber,
        'words': _words,
      },
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature'),
        content: const Text('Tính năng này sẽ được phát triển trong tương lai!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double _calculateAccuracy() {
    if (_words.isEmpty) return 0.0;
    final learnedCount = _words.where((w) => w.isLearned).length;
    return learnedCount / _words.length;
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
