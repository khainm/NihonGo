import 'package:flutter/material.dart';
import '../../domain/entities/kanji_lesson.dart';
import 'kanji_practice_page.dart';

class KanjiCharacter {
  final String character;
  final String meaning;
  final List<String> onYomi;
  final List<String> kunYomi;
  final List<KanjiExample> examples;
  final List<String> radicals;
  final int strokeCount;

  KanjiCharacter({
    required this.character,
    required this.meaning,
    required this.onYomi,
    required this.kunYomi,
    required this.examples,
    required this.radicals,
    required this.strokeCount,
  });
}

class KanjiExample {
  final String word;
  final String reading;
  final String meaning;

  KanjiExample({
    required this.word,
    required this.reading,
    required this.meaning,
  });
}

class KanjiLessonDetailPage extends StatelessWidget {
  final KanjiLesson lesson;
  final Color color;

  const KanjiLessonDetailPage({
    super.key,
    required this.lesson,
    required this.color,
  });

  List<KanjiCharacter> _getKanjiCharacters() {
    // Mock data - replace with actual data from API/database later
    return [
      KanjiCharacter(
        character: '日',
        meaning: 'Ngày, mặt trời',
        onYomi: ['ニチ', 'ジツ'],
        kunYomi: ['ひ', '-び', '-か'],
        examples: [
          KanjiExample(
            word: '日本',
            reading: 'にほん',
            meaning: 'Nhật Bản',
          ),
          KanjiExample(
            word: '今日',
            reading: 'きょう',
            meaning: 'Hôm nay',
          ),
        ],
        radicals: ['日'],
        strokeCount: 4,
      ),
      KanjiCharacter(
        character: '月',
        meaning: 'Tháng, mặt trăng',
        onYomi: ['ゲツ', 'ガツ'],
        kunYomi: ['つき'],
        examples: [
          KanjiExample(
            word: '月曜日',
            reading: 'げつようび',
            meaning: 'Thứ hai',
          ),
          KanjiExample(
            word: '一月',
            reading: 'いちがつ',
            meaning: 'Tháng một',
          ),
        ],
        radicals: ['月'],
        strokeCount: 4,
      ),
    ];
  }

  Widget _buildKanjiCard(KanjiCharacter kanji) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kanji.character,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kanji.meaning,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.brush, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${kanji.strokeCount} nét',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (kanji.onYomi.isNotEmpty) ...[
              Text(
                'Âm On (音読み):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: kanji.onYomi.map((reading) => Chip(
                  label: Text(reading),
                  backgroundColor: color.withOpacity(0.1),
                  labelStyle: TextStyle(color: color),
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],
            if (kanji.kunYomi.isNotEmpty) ...[
              Text(
                'Âm Kun (訓読み):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: kanji.kunYomi.map((reading) => Chip(
                  label: Text(reading),
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(color: Colors.grey[800]),
                )).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Ví dụ:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ...kanji.examples.map((example) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    example.word,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example.reading,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    example.meaning,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kanjiCharacters = _getKanjiCharacters();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${lesson.title} - ${lesson.level}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Navigate to practice/test page
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Luyện tập'),
            style: TextButton.styleFrom(
              foregroundColor: color,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danh sách Kanji',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Học các chữ Kanji dưới đây và nhấn "Luyện tập" để kiểm tra',
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kanjiCharacters.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildKanjiCard(kanjiCharacters[index]),
            ),
            const SizedBox(height: 32),
            // Practice button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KanjiPracticePage(
                        lesson: lesson,
                        color: color,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.fitness_center),
                label: const Text('Bắt đầu luyện tập'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
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
      ),
    );
  }
} 