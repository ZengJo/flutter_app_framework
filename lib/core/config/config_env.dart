class EnvConfig {
  EnvConfig._();

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  /// 是否开启 UME
  static const bool enableUme = bool.fromEnvironment(
    'ENABLE_UME',
    defaultValue: false,
  );

  /// 是否开启调试日志
  static const bool enableLog = bool.fromEnvironment(
    'ENABLE_LOG',
    defaultValue: false,
  );

  /// API 基础 URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// WebSocket 基础 URL
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: '',
  );

  /// 是否为开发环境
  static bool get isDev => env == 'dev';

  /// 是否为生产环境
  static bool get isProd => env == 'prod';

  /// 是否为测试环境
  static bool get isTest => env == 'test';
}
