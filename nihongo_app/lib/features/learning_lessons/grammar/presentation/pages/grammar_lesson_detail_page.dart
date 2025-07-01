import 'package:flutter/material.dart';
import '../../domain/entities/grammar_lesson.dart';
import '../widgets/grammar_point_card.dart';

class GrammarLessonDetailPage extends StatefulWidget {
  final GrammarLesson lesson;
  final Color color;

  const GrammarLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<GrammarLessonDetailPage> createState() => _GrammarLessonDetailPageState();
}

class _GrammarLessonDetailPageState extends State<GrammarLessonDetailPage> {
  late List<GrammarPoint> grammarPoints;
  bool isStudyMode = true; // true = study mode, false = review mode

  @override
  void initState() {
    super.initState();
    grammarPoints = List.from(widget.lesson.grammarPoints);
  }

  void _markGrammarPointAsLearned(int grammarPointId) {
    setState(() {
      final pointIndex = grammarPoints.indexWhere((p) => p.id == grammarPointId);
      if (pointIndex != -1) {
        grammarPoints[pointIndex] = GrammarPoint(
          id: grammarPoints[pointIndex].id,
          pattern: grammarPoints[pointIndex].pattern,
          meaning: grammarPoints[pointIndex].meaning,
          explanation: grammarPoints[pointIndex].explanation,
          usage: grammarPoints[pointIndex].usage,
          examples: grammarPoints[pointIndex].examples,
          relatedPatterns: grammarPoints[pointIndex].relatedPatterns,
          formationRule: grammarPoints[pointIndex].formationRule,
          notes: grammarPoints[pointIndex].notes,
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
    final learnedPoints = grammarPoints.where((p) => p.isLearned).length;
    final progress = grammarPoints.isNotEmpty ? learnedPoints / grammarPoints.length : 0.0;

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
                      Icon(Icons.school, color: widget.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isStudyMode ? 'Đang học ngữ pháp' : 'Ôn tập ngữ pháp',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isStudyMode 
                                  ? 'Học từng điểm ngữ pháp chi tiết'
                                  : 'Ôn tập lại các điểm ngữ pháp đã học',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.category, size: 16, color: widget.color),
                            const SizedBox(width: 4),
                            Text(
                              widget.lesson.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.color,
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
                                  '$learnedPoints/${grammarPoints.length}',
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
            
            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.schedule,
                    title: 'Thời gian học',
                    value: '${widget.lesson.estimatedTime.inMinutes} phút',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.auto_stories,
                    title: 'Điểm ngữ pháp',
                    value: '${grammarPoints.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: isStudyMode ? Icons.school : Icons.quiz,
                    title: isStudyMode ? 'Chế độ học' : 'Chế độ ôn tập',
                    value: isStudyMode ? 'Học' : 'Ôn tập',
                  ),
                ),
              ],
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
                  isStudyMode ? 'Chế độ học chi tiết' : 'Chế độ ôn tập nhanh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Grammar points list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grammarPoints.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final grammarPoint = grammarPoints[index];
                
                // In review mode, only show learned points
                if (!isStudyMode && !grammarPoint.isLearned) {
                  return const SizedBox.shrink();
                }
                
                return GrammarPointCard(
                  grammarPoint: grammarPoint,
                  color: widget.color,
                  onMarkAsLearned: isStudyMode && !grammarPoint.isLearned
                      ? () => _markGrammarPointAsLearned(grammarPoint.id)
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
                  onPressed: learnedPoints == grammarPoints.length 
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

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: widget.color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
