import 'package:flutter/material.dart';
import '../widgets/jlpt_level_card.dart';
import '../widgets/test_section_card.dart';
import '../widgets/recent_test_card.dart';
import '../../../../shared/widgets/app_bottom_navigation_bar.dart';
import 'test_detail_page.dart';

class JLPTTestPage extends StatefulWidget {
  const JLPTTestPage({super.key});

  @override
  State<JLPTTestPage> createState() => _JLPTTestPageState();
}

class _JLPTTestPageState extends State<JLPTTestPage> {
  int _currentIndex = 1; // Set to 1 for the Test tab
  String _selectedLevel = 'N5';

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onLevelSelect(String level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  void _navigateToTestDetail(String section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestDetailPage(
          level: _selectedLevel,
          section: section,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kiểm Tra JLPT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chọn cấp độ để bắt đầu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    JLPTLevelCard(
                      level: 'N5',
                      title: 'Sơ Cấp',
                      progress: 0.65,
                      color: Colors.blue,
                      onTap: () => _onLevelSelect('N5'),
                      onStartPressed: () => _navigateToTestDetail('all'),
                    ),
                    const SizedBox(width: 16),
                    JLPTLevelCard(
                      level: 'N4',
                      title: 'Cơ Bản',
                      progress: 0.40,
                      color: Colors.green,
                      onTap: () => _onLevelSelect('N4'),
                      onStartPressed: () => _navigateToTestDetail('all'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Các Phần Kiểm Tra',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TestSectionCard(
                icon: Icons.book,
                title: 'Ngữ Pháp',
                subtitle: '45 bài kiểm tra',
                //onTap: () => _navigateToTestDetail('grammar'),
              ),
              const SizedBox(height: 12),
              TestSectionCard(
                icon: Icons.library_books,
                title: 'Từ Vựng',
                subtitle: '60 bài kiểm tra',
               // onTap: () => _navigateToTestDetail('vocabulary'),
              ),
              const SizedBox(height: 12),
              TestSectionCard(
                icon: Icons.headphones,
                title: 'Nghe Hiểu',
                subtitle: '30 bài kiểm tra',
                //onTap: () => _navigateToTestDetail('listening'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hoạt Động Gần Đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RecentTestCard(
                title: 'Bài kiểm tra N5 - Ngữ pháp',
                time: '2 giờ trước',
                score: 0.85,
              ),
              const SizedBox(height: 12),
              RecentTestCard(
                title: 'Bài kiểm tra N5 - Ngữ pháp',
                time: '2 giờ trước',
                score: 0.85,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
} 