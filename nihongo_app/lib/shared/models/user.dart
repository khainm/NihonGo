class User {
  final String id;
  final String? name;
  final String email;
  final String? avatarUrl;
  final String? level;
  final int streak;
  final int points;
  final DateTime joinedDate;

  User({
    required this.id,
    this.name,
    required this.email,
    this.avatarUrl,
    this.level,
    this.streak = 0,
    this.points = 0,
    required this.joinedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      level: json['level'],
      streak: json['streak'] ?? 0,
      points: json['points'] ?? 0,
      joinedDate: json['joined_date'] != null 
        ? DateTime.parse(json['joined_date']) 
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'level': level,
      'streak': streak,
      'points': points,
      'joined_date': joinedDate.toIso8601String(),
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? level,
    int? streak,
    int? points,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      points: points ?? this.points,
      joinedDate: this.joinedDate,
    );
  }
}
