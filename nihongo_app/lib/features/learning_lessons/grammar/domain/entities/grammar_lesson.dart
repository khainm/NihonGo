class GrammarLesson {
  final int id;
  final String title;
  final String description;
  final String level;
  final int totalGrammarPoints;
  final int completedGrammarPoints;
  final List<GrammarPoint> grammarPoints;
  final Duration estimatedTime;
  final String category; // e.g., "Particles", "Verb Forms", "Adjectives"

  GrammarLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.totalGrammarPoints,
    required this.completedGrammarPoints,
    required this.grammarPoints,
    required this.estimatedTime,
    required this.category,
  });

  double get progress => totalGrammarPoints > 0 ? completedGrammarPoints / totalGrammarPoints : 0.0;
  bool get isCompleted => completedGrammarPoints >= totalGrammarPoints;
}

class GrammarPoint {
  final int id;
  final String pattern;
  final String meaning;
  final String explanation;
  final String usage;
  final List<GrammarExample> examples;
  final List<String> relatedPatterns;
  final String formationRule;
  final List<String> notes;
  final bool isLearned;

  GrammarPoint({
    required this.id,
    required this.pattern,
    required this.meaning,
    required this.explanation,
    required this.usage,
    required this.examples,
    required this.relatedPatterns,
    required this.formationRule,
    required this.notes,
    this.isLearned = false,
  });
}

class GrammarExample {
  final int id;
  final String japanese;
  final String romaji;
  final String translation;
  final String highlightedPart; // The part that demonstrates the grammar
  final String context; // When/where to use this

  GrammarExample({
    required this.id,
    required this.japanese,
    required this.romaji,
    required this.translation,
    required this.highlightedPart,
    required this.context,
  });
}
