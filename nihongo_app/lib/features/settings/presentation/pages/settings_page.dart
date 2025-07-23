import 'package:flutter/material.dart';
import '../widgets/sound_settings_card.dart';
import '../widgets/dark_mode_card.dart';
import '../widgets/reminder_card.dart';
import '../widgets/offline_mode_card.dart';
import '../widgets/study_plan_card.dart';
import '../widgets/logout_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../../core/di/injection_container.dart' as di;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool soundOn = false;
  String voiceType = 'Nam';
  bool darkMode = false;
  String reminderFrequency = 'Hàng ngày, Hàng tuần';
  double offlineProgress = 0.7;
  String offlineSize = '2.1 GB';

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
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            print('Settings back button pressed'); // Debug log
            try {
              if (Navigator.of(context).canPop()) {
                print('Can pop, calling pop()'); // Debug log
                Navigator.of(context).pop();
              } else {
                print('Cannot pop, navigating to home'); // Debug log
                Navigator.of(context).pushReplacementNamed('/home');
              }
            } catch (e) {
              print('Settings navigation error: $e'); // Debug log
              // Fallback navigation
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
        ),
        title: const Text('Cài đặt', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          SoundSettingsCard(
            soundOn: soundOn,
            onSoundChanged: (v) => setState(() => soundOn = v),
            voiceType: voiceType,
            onVoiceTap: () {},
          ),
          const SizedBox(height: 12),
          DarkModeCard(
            darkMode: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
          ),
          const SizedBox(height: 12),
          ReminderCard(
            onScheduleTap: () {},
            onFrequencyTap: () {},
            frequency: reminderFrequency,
          ),
          const SizedBox(height: 12),
          OfflineModeCard(
            progress: offlineProgress,
            size: offlineSize,
          ),
          const SizedBox(height: 12),
          StudyPlanCard(
            onTap: () {},
          ),
          const SizedBox(height: 12),
          LogoutCard(
            onTap: () => _handleLogout(context),
          ),
          const SizedBox(height: 12),
          // Debug card for token testing
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('Token Test (Debug)'),
              subtitle: const Text('Test authentication token'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/token-test');
              },
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('Phiên bản 1.0.0', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ),
        ],
      ),
    );
  }
} 