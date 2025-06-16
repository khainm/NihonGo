import 'package:flutter/material.dart';

class SoundSettingsCard extends StatelessWidget {
  final bool soundOn;
  final ValueChanged<bool> onSoundChanged;
  final String voiceType;
  final VoidCallback onVoiceTap;

  const SoundSettingsCard({
    super.key,
    required this.soundOn,
    required this.onSoundChanged,
    required this.voiceType,
    required this.onVoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cài đặt âm thanh', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.volume_up_rounded, color: Colors.grey),
                const SizedBox(width: 8),
                const Expanded(child: Text('Bật/Tắt âm thanh')),
                Switch(value: soundOn, onChanged: onSoundChanged),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onVoiceTap,
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Giọng đọc')),
                  Text(voiceType, style: TextStyle(color: Colors.grey[700])),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 