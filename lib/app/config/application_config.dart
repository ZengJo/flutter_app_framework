/// Centralized application metadata and runtime configuration.
class ApplicationConfig {
  const ApplicationConfig._();

  static const String appName = 'Flutter App Framework';
  static const String defaultEnvironment = 'development';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
