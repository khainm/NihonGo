import 'package:flutter/material.dart';
import '../../data/services/jlpt_progress_service.dart';

class ProgressTestPage extends StatefulWidget {
  const ProgressTestPage({super.key});

  @override
  State<ProgressTestPage> createState() => _ProgressTestPageState();
}

class _ProgressTestPageState extends State<ProgressTestPage> {
  final JlptProgressService _progressService = JlptProgressService();
  String _result = 'Ready to test';
  bool _isLoading = false;

  Future<void> _testProgressUpdate() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing progress update...';
    });

    try {
      final success = await _progressService.updateWordProgress(
        jlptLevel: 'N5',
        lessonId: 'bai_1',
        wordId: 'test_word_123',
        isLearned: true,
      );

      setState(() {
        _result = success 
            ? 'SUCCESS: Progress updated!' 
            : 'FAILED: Could not update progress';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'ERROR: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress API Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Test JLPT Progress API',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _testProgressUpdate,
                    child: const Text('Test Progress Update'),
                  ),
          ],
        ),
      ),
    );
  }
}
