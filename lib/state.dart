// state.dart
class ApiConfig {
  static const String baseUrl = 'http://54.154.146.235:8080/api';
  
  static String get signIn => '$baseUrl/signin';
  static String get signUp => '$baseUrl/signup';
  static String get logout => '$baseUrl/logout';
  static String get doctorai => '$baseUrl/doctorai';
}