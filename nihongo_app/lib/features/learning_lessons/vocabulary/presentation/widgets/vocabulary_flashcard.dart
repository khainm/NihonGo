import 'package:flutter/material.dart';
import '../../domain/entities/jlpt_vocabulary.dart';

class VocabularyFlashcard extends StatefulWidget {
  final JlptVocabularyWord word;
  final bool showBack;
  final VoidCallback onTap;

  const VocabularyFlashcard({
    super.key,
    required this.word,
    required this.showBack,
    required this.onTap,
  });

  @override
  State<VocabularyFlashcard> createState() => _VocabularyFlashcardState();
}

class _VocabularyFlashcardState extends State<VocabularyFlashcard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VocabularyFlashcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != oldWidget.showBack) {
      if (widget.showBack) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value * 3.14159),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.showBack
                        ? [
                            Colors.green.withOpacity(0.1),
                            Colors.blue.withOpacity(0.1),
                          ]
                        : [
                            Colors.blue.withOpacity(0.1),
                            Colors.purple.withOpacity(0.1),
                          ],
                  ),
                ),
                child: _animation.value < 0.5
                    ? _buildFrontSide()
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: _buildBackSide(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Japanese text
          Text(
            widget.word.japanese,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // Reading (if available)
          if (widget.word.reading != null && widget.word.reading!.isNotEmpty) ...[
            Text(
              widget.word.reading!,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
          
          // Tap instruction
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Text(
              'Chạm để xem nghĩa',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Japanese text (smaller)
          Text(
            widget.word.japanese,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Reading (if available)
          if (widget.word.reading != null && widget.word.reading!.isNotEmpty) ...[
            Text(
              widget.word.reading!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
          
          // Divider
          Container(
            width: 100,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Vietnamese meaning
          Text(
            widget.word.vietnamese,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Notes (if available)
          if (widget.word.notes != null && widget.word.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                widget.word.notes!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Tap instruction
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Text(
              'Chạm để lật lại',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
