import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_quick_stat.dart';
import '../widgets/profile_goal_progress.dart';
import '../widgets/profile_badge.dart';
import '../widgets/profile_action_button.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            print('Back button pressed'); // Debug log
            try {
              if (Navigator.of(context).canPop()) {
                print('Can pop, calling pop()'); // Debug log
                Navigator.of(context).pop();
              } else {
                print('Cannot pop, navigating to home'); // Debug log
                Navigator.of(context).pushReplacementNamed('/home');
              }
            } catch (e) {
              print('Navigation error: $e'); // Debug log
              // Fallback navigation
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF4A90E2)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ProfileHeader(
            avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
            name: 'Nguyễn Văn A',
            email: 'nguyenvana@email.com',
            level: 'JLPT N4',
            onEdit: () {},
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ProfileQuickStat(
                icon: Icons.menu_book_rounded,
                label: 'Từ vựng hôm nay',
                value: '15/20',
                color: Color(0xFFB3D6FF),
              ),
              ProfileQuickStat(
                icon: Icons.local_fire_department_rounded,
                label: 'Chuỗi ngày học',
                value: '7 ngày',
                color: Color(0xFFFFF2E0),
              ),
              ProfileQuickStat(
                icon: Icons.star_border_rounded,
                label: 'Tổng điểm',
                value: '2,450',
                color: Color(0xFFF3F0FF),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Mục tiêu hằng ngày', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: const [
              ProfileGoalProgress(label: 'Từ vựng', percent: 0.75),
              SizedBox(width: 16),
              ProfileGoalProgress(label: 'Ngữ pháp', percent: 0.6),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Huy hiệu của bạn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ProfileBadge(icon: Icons.rocket_launch_rounded, label: 'Siêu nhân từ vựng', color: Color(0xFFE3F0FF)),
              ProfileBadge(icon: Icons.local_fire_department_rounded, label: 'Chuỗi 7 ngày', color: Color(0xFFFFF2E0)),
              ProfileBadge(icon: Icons.star_border_rounded, label: 'Bậc thầy Kanji', color: Color(0xFFFFF9E3)),
            ],
          ),
          const SizedBox(height: 28),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: [
              ProfileActionButton(icon: Icons.bar_chart_rounded, label: 'Đặt lại mục tiêu', onTap: () {}),
              ProfileActionButton(icon: Icons.access_time_rounded, label: 'Thay đổi cấp độ JLPT', onTap: () {}),
              ProfileActionButton(icon: Icons.shield_rounded, label: 'Cài đặt bảo mật', onTap: () {}),
              ProfileActionButton(icon: Icons.settings, label: 'Cài đặt', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
} 