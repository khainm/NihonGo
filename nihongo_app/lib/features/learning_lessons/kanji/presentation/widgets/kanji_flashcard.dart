import 'package:flutter/material.dart';
import '../../domain/entities/kanji_lesson.dart';

class KanjiFlashcard extends StatefulWidget {
  final KanjiLesson lesson;
  final Color color;

  const KanjiFlashcard({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<KanjiFlashcard> createState() => _KanjiFlashcardState();
}

class _KanjiFlashcardState extends State<KanjiFlashcard> {
  int _currentIndex = 0;
  bool _showMeaning = false;
  
  // Mock data - replace with actual data
  final List<Map<String, dynamic>> kanjiData = [
    {
      'character': '人',
      'meaning': 'người',
      'meaningEn': 'person',
      'onyomi': ['ジン', 'ニン'],
      'kunyomi': ['ひと'],
      'strokeCount': 2,
    },
    {
      'character': '日',
      'meaning': 'ngày, mặt trời',
      'meaningEn': 'day, sun',
      'onyomi': ['ニチ', 'ジツ'],
      'kunyomi': ['ひ', 'か'],
      'strokeCount': 4,
    },
    {
      'character': '本',
      'meaning': 'sách, gốc',
      'meaningEn': 'book, origin',
      'onyomi': ['ホン'],
      'kunyomi': ['もと'],
      'strokeCount': 5,
    },
    {
      'character': '学',
      'meaning': 'học',
      'meaningEn': 'study, learn',
      'onyomi': ['ガク'],
      'kunyomi': ['まな'],
      'strokeCount': 8,
    },
    {
      'character': '時',
      'meaning': 'thời gian',
      'meaningEn': 'time',
      'onyomi': ['ジ'],
      'kunyomi': ['とき'],
      'strokeCount': 10,
    },
  ];

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % kanjiData.length;
      _showMeaning = false;
    });
  }

  void _previousCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + kanjiData.length) % kanjiData.length;
      _showMeaning = false;
    });
  }

  void _toggleMeaning() {
    setState(() {
      _showMeaning = !_showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentKanji = kanjiData[_currentIndex];
    
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
                Icon(Icons.credit_card, color: widget.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flashcard Kanji',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      Text(
                        'Nhấp vào thẻ để xem nghĩa',
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
          
          // Card counter
          Text(
            '${_currentIndex + 1} / ${kanjiData.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Flashcard
          GestureDetector(
            onTap: _toggleMeaning,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _showMeaning ? _buildMeaningCard(currentKanji) : _buildKanjiCard(currentKanji),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(
                icon: Icons.arrow_back,
                label: 'Trước',
                onPressed: _previousCard,
              ),
              _buildNavButton(
                icon: _showMeaning ? Icons.visibility_off : Icons.visibility,
                label: _showMeaning ? 'Ẩn' : 'Hiện',
                onPressed: _toggleMeaning,
                isPrimary: true,
              ),
              _buildNavButton(
                icon: Icons.arrow_forward,
                label: 'Tiếp',
                onPressed: _nextCard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKanjiCard(Map<String, dynamic> kanji) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            kanji['character'],
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
              '${kanji['strokeCount']} nét',
              style: TextStyle(
                fontSize: 14,
                color: widget.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nhấp để xem nghĩa',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningCard(Map<String, dynamic> kanji) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            kanji['character'],
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            kanji['meaning'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            kanji['meaningEn'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildReadingSection('Âm On', kanji['onyomi']),
          const SizedBox(height: 12),
          _buildReadingSection('Âm Kun', kanji['kunyomi']),
        ],
      ),
    );
  }

  Widget _buildReadingSection(String title, List<String> readings) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: readings.map((reading) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              reading,
              style: TextStyle(
                fontSize: 14,
                color: widget.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? widget.color : Colors.grey[100],
        foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
        elevation: isPrimary ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
