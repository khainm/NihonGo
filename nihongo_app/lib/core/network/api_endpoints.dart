class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  
  // Course endpoints
  static const String courses = '/courses';
  static const String recommendedCourses = '/courses/recommended';
  static String courseDetail(String id) => '/courses/$id';
  static String courseLessons(String id) => '/courses/$id/lessons';
  
  // Lesson endpoints
  static String lessonDetail(String id) => '/lessons/$id';
  static String lessonProgress(String id) => '/lessons/$id/progress';
  
  // Progress endpoints
  static const String userProgress = '/user/progress';
  static const String dailyGoals = '/user/goals';
  
  // JLPT endpoints
  static const String jlptLevels = '/jlpt/levels';
  static const String jlptTests = '/jlpt/tests';
  static const String jlptHistory = '/jlpt/history';
}
