import 'app_environment.dart';

/// Centralized application metadata and runtime configuration.
class ApplicationConfig {
  const ApplicationConfig._();

  static const String appName = 'Flutter App Framework';
  static const AppEnvironment environment = AppEnvironment.development;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
