class AppConstants {
  static const String baseUrl = 'http://localhost:3000';
  static const Duration requestTimeout = Duration(seconds: 30);

  // Kalau nanti mau pakai JWT Bearer token juga bisa kayak gini
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Key untuk menyimpan cookie/token di storage
  static const String storageKeyCookie = 'cookie';
}