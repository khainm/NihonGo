import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_levels_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_lessons_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_lesson_detail_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_vocabulary_practice_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_vocabulary_flashcard_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/jlpt_vocabulary_quiz_page.dart';
import 'features/learning_lessons/vocabulary/presentation/pages/vocabulary_debug_page.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          primary: AppTheme.primaryColor,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        // Override default text theme
        textTheme: const TextTheme(
          headlineLarge: AppTheme.titleTextStyle,
          bodyLarge: TextStyle(color: AppTheme.textColor),
          bodyMedium: TextStyle(color: AppTheme.textColor),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/jlpt-levels': (context) => const JlptLevelsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/jlpt-lessons') {
          final args = settings.arguments as Map<String, dynamic>?;
          final jlptLevel = args?['jlptLevel'] ?? 'N5';
          return MaterialPageRoute(
            builder: (context) => JlptLessonsPage(jlptLevel: jlptLevel),
          );
        }
        // TODO: Add route for lesson detail page
        if (settings.name == '/jlpt-lesson-detail') {
          final args = settings.arguments as Map<String, dynamic>?;
          final jlptLevel = args?['jlptLevel'] ?? 'N5';
          final lessonId = args?['lessonId'] ?? '';
          
          // Extract lesson number from lessonId (e.g., "n5_bai_1" -> 1)
          final lessonNumber = int.tryParse(
            lessonId.split('_').last
          ) ?? 1;
          
          return MaterialPageRoute(
            builder: (context) => JlptLessonDetailPage(
              level: jlptLevel,
              lessonNumber: lessonNumber,
              color: _getLevelColor(jlptLevel),
            ),
          );
        }
        // Route for practice page
        if (settings.name == '/jlpt-vocabulary/practice') {
          final args = settings.arguments as Map<String, dynamic>?;
          final jlptLevel = args?['jlptLevel'] ?? 'N5';
          final lessonNumber = args?['lessonNumber'] ?? 1;
          
          return MaterialPageRoute(
            builder: (context) => JlptVocabularyPracticePage(
              jlptLevel: jlptLevel,
              lessonNumber: lessonNumber,
            ),
          );
        }
        // Route for flashcard practice
        if (settings.name == '/jlpt-vocabulary/practice/flashcard') {
          final args = settings.arguments as Map<String, dynamic>?;
          final jlptLevel = args?['jlptLevel'] ?? 'N5';
          final lessonNumber = args?['lessonNumber'] ?? 1;
          final words = args?['words'] ?? [];
          
          return MaterialPageRoute(
            builder: (context) => JlptVocabularyFlashcardPage(
              jlptLevel: jlptLevel,
              lessonNumber: lessonNumber,
              words: words,
            ),
          );
        }
        // Route for quiz practice
        if (settings.name == '/jlpt-vocabulary/practice/quiz') {
          final args = settings.arguments as Map<String, dynamic>?;
          final jlptLevel = args?['jlptLevel'] ?? 'N5';
          final lessonNumber = args?['lessonNumber'] ?? 1;
          final words = args?['words'] ?? [];
          
          return MaterialPageRoute(
            builder: (context) => JlptVocabularyQuizPage(
              jlptLevel: jlptLevel,
              lessonNumber: lessonNumber,
              words: words,
            ),
          );
        }
        // Route for debug page
        if (settings.name == '/vocabulary-debug') {
          return MaterialPageRoute(
            builder: (context) => const VocabularyDebugPage(),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'N5':
        return const Color(0xFF2196F3); // Blue
      case 'N4':
        return const Color(0xFF4CAF50); // Green
      case 'N3':
        return const Color(0xFFFF9800); // Orange
      case 'N2':
        return const Color(0xFFE91E63); // Pink
      case 'N1':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF2196F3);
    }
  }
}
