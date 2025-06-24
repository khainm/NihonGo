import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_bottom_navigation_bar.dart';
import '../widgets/test_card.dart';
import '../widgets/recent_result_card.dart';

class TestDetailPage extends StatefulWidget {
  final String level;
  final String section;

  const TestDetailPage({
    super.key,
    required this.level,
    required this.section,
  });

  @override
  State<TestDetailPage> createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> {
  int _currentIndex = 1; // Set to 1 for the Test tab

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTestStart() {
    // TODO: Implement test start logic
  }

  void _onTestContinue() {
    // TODO: Implement test continue logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kiểm Tra Năng Lực',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kiểm tra kiến thức để xác định trình độ hiện tại của bạn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              TestCard(
                icon: Icons.description,
                title: 'Kiểm Tra Ngữ Pháp',
                level: widget.level,
                duration: '20 phút',
                questions: '20 câu trắc nghiệm',
                onActionPressed: _onTestStart,
              ),
              TestCard(
                icon: Icons.menu_book,
                title: 'Kiểm Tra Từ Vựng',
                level: widget.level,
                duration: '15 phút',
                questions: '15 câu trắc nghiệm',
                isInProgress: true,
                onActionPressed: _onTestContinue,
              ),
              TestCard(
                icon: Icons.headphones,
                title: 'Luyện Nghe',
                level: widget.level,
                duration: '10 phút',
                questions: '10 câu hỏi',
                onActionPressed: _onTestStart,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kết Quả Gần Đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const RecentResultCard(
                score: '85/100',
                date: '16/06/2025',
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