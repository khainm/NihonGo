import 'package:flutter/material.dart';
import '../../domain/entities/kanji_lesson.dart';

class StrokeOrderPractice extends StatefulWidget {
  final KanjiLesson lesson;
  final Color color;

  const StrokeOrderPractice({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<StrokeOrderPractice> createState() => _StrokeOrderPracticeState();
}

class _StrokeOrderPracticeState extends State<StrokeOrderPractice> with TickerProviderStateMixin {
  int _currentKanjiIndex = 0;
  int _currentStroke = 0;
  late AnimationController _animationController;
  
  // Mock stroke order data
  final List<Map<String, dynamic>> kanjiStrokeData = [
    {
      'character': '人',
      'strokes': [
        {'path': 'M10,10 L50,80', 'description': 'Nét 1: Từ trên xuống, nghiêng trái'},
        {'path': 'M50,30 L90,80', 'description': 'Nét 2: Từ trái sang phải, nghiêng xuống'},
      ],
    },
    {
      'character': '日',
      'strokes': [
        {'path': 'M20,10 L20,90', 'description': 'Nét 1: Dọc bên trái'},
        {'path': 'M80,10 L80,90', 'description': 'Nét 2: Dọc bên phải'},
        {'path': 'M20,10 L80,10', 'description': 'Nét 3: Ngang trên'},
        {'path': 'M20,90 L80,90', 'description': 'Nét 4: Ngang dưới'},
      ],
    },
    {
      'character': '本',
      'strokes': [
        {'path': 'M50,10 L50,90', 'description': 'Nét 1: Dọc giữa'},
        {'path': 'M20,30 L80,30', 'description': 'Nét 2: Ngang trên'},
        {'path': 'M30,50 L70,50', 'description': 'Nét 3: Ngang giữa ngắn'},
        {'path': 'M10,70 L40,70', 'description': 'Nét 4: Ngang trái dưới'},
        {'path': 'M60,70 L90,70', 'description': 'Nét 5: Ngang phải dưới'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStroke() {
    final currentKanji = kanjiStrokeData[_currentKanjiIndex];
    if (_currentStroke < currentKanji['strokes'].length - 1) {
      setState(() {
        _currentStroke++;
      });
    }
  }

  void _previousStroke() {
    if (_currentStroke > 0) {
      setState(() {
        _currentStroke--;
      });
    }
  }

  void _resetStrokes() {
    setState(() {
      _currentStroke = 0;
    });
  }

  void _playAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _nextKanji() {
    if (_currentKanjiIndex < kanjiStrokeData.length - 1) {
      setState(() {
        _currentKanjiIndex++;
        _currentStroke = 0;
      });
    }
  }

  void _previousKanji() {
    if (_currentKanjiIndex > 0) {
      setState(() {
        _currentKanjiIndex--;
        _currentStroke = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentKanji = kanjiStrokeData[_currentKanjiIndex];
    final strokes = currentKanji['strokes'] as List;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
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
                Icon(Icons.brush, color: widget.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Luyện viết nét',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      Text(
                        'Học cách viết kanji đúng thứ tự nét',
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
          
          // Kanji navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kanji ${_currentKanjiIndex + 1}/${kanjiStrokeData.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _currentKanjiIndex > 0 ? _previousKanji : null,
                    icon: const Icon(Icons.skip_previous),
                    color: widget.color,
                  ),
                  IconButton(
                    onPressed: _currentKanjiIndex < kanjiStrokeData.length - 1 ? _nextKanji : null,
                    icon: const Icon(Icons.skip_next),
                    color: widget.color,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Kanji display area
          Container(
            width: double.infinity,
            height: 300,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentKanji['character'],
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Nét ${_currentStroke + 1}/${strokes.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stroke description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hướng dẫn nét ${_currentStroke + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strokes[_currentStroke]['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.skip_previous,
                label: 'Nét trước',
                onPressed: _currentStroke > 0 ? _previousStroke : null,
              ),
              _buildControlButton(
                icon: Icons.play_arrow,
                label: 'Xem demo',
                onPressed: _playAnimation,
                isPrimary: true,
              ),
              _buildControlButton(
                icon: Icons.skip_next,
                label: 'Nét tiếp',
                onPressed: _currentStroke < strokes.length - 1 ? _nextStroke : null,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Reset button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetStrokes,
              icon: const Icon(Icons.refresh),
              label: const Text('Xem lại từ đầu'),
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.color,
                side: BorderSide(color: widget.color),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stroke order guide
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
                      'Mẹo viết Kanji',
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
                  '• Viết từ trên xuống dưới\n'
                  '• Viết từ trái sang phải\n'
                  '• Viết nét ngang trước nét dọc\n'
                  '• Viết phần bên trái trước phần bên phải',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? widget.color : Colors.grey[100],
        foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
        elevation: isPrimary ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
