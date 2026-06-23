enum AppEnvironment { development, staging, production }

extension AppEnvironmentX on AppEnvironment {
  String get name => switch (this) {
        AppEnvironment.development => 'development',
        AppEnvironment.staging => 'staging',
        AppEnvironment.production => 'production',
      };
}
