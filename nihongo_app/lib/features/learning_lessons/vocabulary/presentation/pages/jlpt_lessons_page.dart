import 'package:flutter/material.dart';
import '../../../vocabulary/domain/entities/jlpt_vocabulary.dart';
import '../../../vocabulary/data/datasources/jlpt_vocabulary_data_repository.dart';
import '../../../vocabulary/data/services/jlpt_vocabulary_api_service.dart';

class JlptLessonsPage extends StatefulWidget {
  final String jlptLevel;

  const JlptLessonsPage({
    super.key,
    required this.jlptLevel,
  });

  @override
  State<JlptLessonsPage> createState() => _JlptLessonsPageState();
}

class _JlptLessonsPageState extends State<JlptLessonsPage> {
  final JlptVocabularyApiService _apiService = JlptVocabularyApiService();
  List<JlptVocabularyLesson> _lessons = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final lessons = await _apiService.getAllLessons(jlptLevel: widget.jlptLevel);
      
      // Nếu API không trả về data, fallback về static data
      if (lessons.isEmpty) {
        final repository = JlptVocabularyDataRepository();
        final staticLessons = await repository.getLessonsByLevel(widget.jlptLevel);
        setState(() {
          _lessons = staticLessons;
          _isLoading = false;
        });
      } else {
        setState(() {
          _lessons = lessons;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading lessons: $e');
      // Fallback to static data on error
      try {
        final repository = JlptVocabularyDataRepository();
        final staticLessons = await repository.getLessonsByLevel(widget.jlptLevel);
        setState(() {
          _lessons = staticLessons;
          _hasError = true;
          _isLoading = false;
        });
      } catch (fallbackError) {
        print('Error loading fallback data: $fallbackError');
        setState(() {
          _lessons = [];
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(widget.jlptLevel);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JLPT ${widget.jlptLevel}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              '${_lessons.length} bài học',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error banner
                  if (_hasError)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Không thể kết nối server. Hiển thị dữ liệu offline.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[800],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _loadLessons,
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),
                  
                  // Header info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book, color: color, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Học từ vựng ${widget.jlptLevel}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Từ vựng được phân chia theo chủ đề và độ khó',
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
                  
                  // Progress overview
                  if (_lessons.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${_lessons.where((l) => l.isCompleted).length}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const Text(
                                  'Bài hoàn thành',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${_lessons.fold(0, (sum, l) => sum + l.completedWords)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const Text(
                                  'Từ đã học',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${_lessons.fold(0, (sum, l) => sum + l.totalWords)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const Text(
                                  'Tổng từ vựng',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Lessons list
                  Text(
                    'Danh sách bài học',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (_lessons.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.construction,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Đang cập nhật nội dung ${widget.jlptLevel}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _lessons.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lesson = _lessons[index];
                        return _buildLessonCard(context, lesson, color);
                      },
                    ),
                ],
              ),
            ),
    );
  }  Widget _buildLessonCard(BuildContext context, JlptVocabularyLesson lesson, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: lesson.totalWords > 0 ? () {
            Navigator.pushNamed(
              context,
              '/jlpt-lesson-detail',
              arguments: {
                'jlptLevel': lesson.jlptLevel,
                'lessonId': lesson.lessonId,
              }
            );
          } : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Progress circle
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: lesson.progressPercentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Lesson info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLessonDisplayName(lesson),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lesson.totalWords} từ vựng',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (lesson.totalWords > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${lesson.completedWords}/${lesson.totalWords} từ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (lesson.isCompleted)
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: color,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  lesson.totalWords > 0 ? Icons.arrow_forward_ios : Icons.hourglass_empty,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLessonDisplayName(JlptVocabularyLesson lesson) {
    // Extract lesson number from lessonId (e.g., "bai_1" -> "Bài 1")
    final lessonId = lesson.lessonId;
    if (lessonId.startsWith('bai_')) {
      final lessonNumber = lessonId.substring(4); // Remove "bai_" prefix
      try {
        final number = int.parse(lessonNumber);
        return 'Bài $number';
      } catch (e) {
        // If parsing fails, fall back to original title
        return lesson.title;
      }
    }
    
    // If lessonId doesn't follow expected pattern, use title
    return lesson.title;
  }

  Color _getLevelColor(String jlptLevel) {
    switch (jlptLevel) {
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
