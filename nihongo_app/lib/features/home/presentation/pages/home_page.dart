import 'package:flutter/material.dart';
import '../widgets/level_card.dart';
import '../widgets/course_card.dart';
import '../widgets/progress_card.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onBottomNavTap(int index) {
    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '日本語',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Xin chào,', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Học viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings_rounded, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Chọn cấp độ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                LevelCard(
                  title: 'N5',
                  subtitle: 'Sơ cấp',
                  percent: 0.65,
                  color: Color(0xFF4A90E2),
                ),
                SizedBox(width: 16),
                LevelCard(
                  title: 'N4',
                  subtitle: 'Cơ bản',
                  percent: 0.4,
                  color: Color(0xFF3ED598),
                ),
                SizedBox(width: 8),
                // Thanh màu vàng
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFC542),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: SizedBox(width: 6, height: 80),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Khóa học đề xuất cho bạn',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const CourseCard(
              image: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
              title: 'Ngữ pháp N5 cơ bản',
              duration: '2 giờ 30 phút',
              lessons: 12,
            ),
            SizedBox(height: 12),
            const CourseCard(
              image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
              title: 'Từ vựng chủ đề ẩm thực',
              duration: '1 giờ 45 phút',
              lessons: 8,
            ),
            SizedBox(height: 12),
            const CourseCard(
              image: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
              title: 'Luyện nghe JLPT N5',
              duration: '3 giờ',
              lessons: 15,
            ),
            SizedBox(height: 28),
            const Text(
              'Tiến độ học tập',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ProgressCard(title: 'Thời gian học', value: '45 phút'),
                ProgressCard(title: 'Bài học hoàn thành', value: '12'),
                ProgressCard(title: 'Điểm tích lũy', value: '280'),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Học tập',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: 'Kiểm tra',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Tiến độ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
