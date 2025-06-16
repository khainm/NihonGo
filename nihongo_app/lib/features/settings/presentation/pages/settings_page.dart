import 'package:flutter/material.dart';
import '../widgets/sound_settings_card.dart';
import '../widgets/dark_mode_card.dart';
import '../widgets/reminder_card.dart';
import '../widgets/offline_mode_card.dart';
import '../widgets/study_plan_card.dart';
import '../widgets/logout_card.dart';

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
            onTap: () {},
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