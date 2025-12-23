/// Application configuration for Plant Detection App
class AppConfig {
  // API Configuration
  // Change this to your server URL when deploying
  // For local development: http://localhost:8000
  // For Android emulator: http://10.0.2.2:8000
  // For production: https://your-api-domain.com
  static const String apiBaseUrl = 'http://localhost:8000';

  // API Endpoints
  static const String predictEndpoint = '/predict';
  static const String healthEndpoint = '/health';

  // Timeout settings (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 60;

  // Image settings
  static const double maxImageWidth = 1024;
  static const double maxImageHeight = 1024;
  static const int imageQuality = 85;
}
