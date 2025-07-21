import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/jlpt_progress_service.dart';
import '../../data/services/jlpt_vocabulary_api_service.dart';

class VocabularyDebugPage extends StatefulWidget {
  const VocabularyDebugPage({super.key});

  @override
  State<VocabularyDebugPage> createState() => _VocabularyDebugPageState();
}

class _VocabularyDebugPageState extends State<VocabularyDebugPage> {
  final JlptProgressService _progressService = JlptProgressService();
  final JlptVocabularyApiService _apiService = JlptVocabularyApiService();
  String _debugInfo = '';
  bool _isLoading = false;

  Future<void> _checkAuth() async {
    setState(() {
      _isLoading = true;
      _debugInfo = 'Checking authentication...\n';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('user_email');
      
      setState(() {
        _debugInfo += 'Token: ${token != null ? "✓ Found" : "✗ Not found"}\n';
        _debugInfo += 'Email: ${email ?? "Not found"}\n';
      });

      if (token == null) {
        // Create a dummy token for testing
        await prefs.setString('auth_token', 'dummy_token_for_testing');
        await prefs.setString('user_email', 'test@example.com');
        setState(() {
          _debugInfo += '\n✓ Created dummy token for testing\n';
        });
      }
    } catch (e) {
      setState(() {
        _debugInfo += 'Error: $e\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testProgressAPI() async {
    setState(() {
      _isLoading = true;
      _debugInfo += '\nTesting Progress API...\n';
    });

    try {
      final success = await _progressService.updateWordProgress(
        jlptLevel: 'N5',
        lessonId: 'n5_bai_1',
        wordId: 'test_word_123',
        isLearned: true,
      );

      setState(() {
        _debugInfo += success 
            ? '✓ Progress API working!\n'
            : '✗ Progress API failed\n';
      });
    } catch (e) {
      setState(() {
        _debugInfo += '✗ Progress API error: $e\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testVocabularyAPI() async {
    setState(() {
      _isLoading = true;
      _debugInfo += '\nTesting Vocabulary API...\n';
    });

    try {
      final lesson = await _apiService.getLessonWithProgress(
        jlptLevel: 'N5',
        lessonNumber: 1,
      );

      setState(() {
        if (lesson != null) {
          _debugInfo += '✓ Vocabulary API working!\n';
          _debugInfo += 'Lesson: ${lesson.title}\n';
          _debugInfo += 'Words: ${lesson.vocabulary.length}\n';
          _debugInfo += 'Learned: ${lesson.vocabulary.where((w) => w.isLearned).length}\n';
        } else {
          _debugInfo += '✗ Vocabulary API returned null\n';
        }
      });
    } catch (e) {
      setState(() {
        _debugInfo += '✗ Vocabulary API error: $e\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _clearDebug() {
    setState(() {
      _debugInfo = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Debug'),
        actions: [
          IconButton(
            onPressed: _clearDebug,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkAuth,
                    child: const Text('Check Auth'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testProgressAPI,
                    child: const Text('Test Progress'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testVocabularyAPI,
                child: const Text('Test Vocabulary API'),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _debugInfo.isEmpty ? 'No debug info yet...' : _debugInfo,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
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
