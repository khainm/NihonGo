enum LessonStatus {
  completed,
  notStarted,
}

class LessonItem {
  final String title;
  final int questionCount;
  final int duration;
  final LessonStatus status;

  const LessonItem({
    required this.title,
    required this.questionCount,
    required this.duration,
    required this.status,
  });
} 