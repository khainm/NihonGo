import 'package:flutter/material.dart';
import '../../domain/entities/grammar_lesson.dart';

class GrammarPointCard extends StatefulWidget {
  final GrammarPoint grammarPoint;
  final Color color;
  final VoidCallback? onMarkAsLearned;

  const GrammarPointCard({
    super.key,
    required this.grammarPoint,
    required this.color,
    this.onMarkAsLearned,
  });

  @override
  State<GrammarPointCard> createState() => _GrammarPointCardState();
}

class _GrammarPointCardState extends State<GrammarPointCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với pattern và status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.grammarPoint.pattern,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.grammarPoint.meaning,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            widget.grammarPoint.isLearned 
                                ? Icons.check_circle 
                                : Icons.radio_button_unchecked,
                            color: widget.grammarPoint.isLearned 
                                ? Colors.green 
                                : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.grammarPoint.isLearned ? 'Đã học' : 'Chưa học',
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.grammarPoint.isLearned 
                                  ? Colors.green 
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.onMarkAsLearned != null && !widget.grammarPoint.isLearned)
                  IconButton(
                    onPressed: widget.onMarkAsLearned,
                    icon: Icon(
                      Icons.check,
                      color: widget.color,
                    ),
                    tooltip: 'Đánh dấu đã học',
                  ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Explanation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giải thích:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.grammarPoint.explanation,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            if (isExpanded) ...[
              const SizedBox(height: 16),
              
              // Formation Rule
              if (widget.grammarPoint.formationRule.isNotEmpty) ...[
                _buildSection(
                  title: 'Cách tạo:',
                  content: widget.grammarPoint.formationRule,
                  icon: Icons.construction,
                ),
                const SizedBox(height: 12),
              ],
              
              // Usage
              if (widget.grammarPoint.usage.isNotEmpty) ...[
                _buildSection(
                  title: 'Cách sử dụng:',
                  content: widget.grammarPoint.usage,
                  icon: Icons.lightbulb_outline,
                ),
                const SizedBox(height: 12),
              ],
              
              // Examples
              if (widget.grammarPoint.examples.isNotEmpty) ...[
                Text(
                  'Ví dụ:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.grammarPoint.examples.map((example) => 
                  _buildExampleCard(example)
                ).toList(),
                const SizedBox(height: 12),
              ],
              
              // Notes
              if (widget.grammarPoint.notes.isNotEmpty) ...[
                _buildNotesSection(),
                const SizedBox(height: 12),
              ],
              
              // Related Patterns
              if (widget.grammarPoint.relatedPatterns.isNotEmpty) ...[
                _buildRelatedPatternsSection(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: widget.color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(GrammarExample example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.japanese,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            example.romaji,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example.translation,
            style: const TextStyle(fontSize: 14),
          ),
          if (example.context.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '💡 ${example.context}',
              style: TextStyle(
                fontSize: 12,
                color: widget.color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                'Lưu ý:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.grammarPoint.notes.map((note) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: Colors.amber[700])),
                  Expanded(
                    child: Text(
                      note,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildRelatedPatternsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngữ pháp liên quan:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.grammarPoint.relatedPatterns.map((pattern) =>
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.color.withOpacity(0.3)),
                ),
                child: Text(
                  pattern,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
}
