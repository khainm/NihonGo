class ListeningLesson {
  final int id;
  final String title;
  final String description;
  final int totalExercises;
  final int completedExercises;
  final String level;
  final Duration duration;

  ListeningLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.totalExercises,
    required this.completedExercises,
    required this.level,
    required this.duration,
  });
} 