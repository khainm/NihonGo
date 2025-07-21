class ApiConstants {
  // Base URLs for different environments
  static const String _baseUrlLocal = 'http://10.0.2.2:8080'; // For Android Emulator
  
  // Choose base URL based on platform
  static String get baseUrl {
    // You can add platform detection here if needed
    return _baseUrlLocal; // Default to Android emulator
  }
  
  // API Endpoints
  static const String authBasePath = '/api/auth';
  static const String registerEndpoint = '$authBasePath/register';
  static const String loginEndpoint = '$authBasePath/login';
  
  // Full URLs
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
}
