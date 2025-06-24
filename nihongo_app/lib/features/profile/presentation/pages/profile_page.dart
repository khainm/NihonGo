import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_quick_stat.dart';
import '../widgets/profile_goal_progress.dart';
import '../widgets/profile_badge.dart';
import '../widgets/profile_action_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../../core/di/injection_container.dart' as di;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Tạo AuthBloc và trigger logout event
                final authBloc = di.sl<AuthBloc>();
                authBloc.add(const LogoutEvent());
                
                // Navigate to login page và clear all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
              ProfileActionButton(
                icon: Icons.logout_rounded, 
                label: 'Đăng xuất', 
                onTap: () => _handleLogout(context), 
                color: Colors.red
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
} 