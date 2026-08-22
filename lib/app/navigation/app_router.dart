import 'package:flutter/material.dart';

import '../../features/example/presentation/pages/example_page.dart';
import '../../features/settings/language/presentation/pages/language_settings_page.dart';
import 'app_navigator.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.example:
        return _pageRoute(settings, const ExamplePage());
      case RouteNames.languageSettings:
        return _pageRoute(settings, const LanguageSettingsPage());
      default:
        return _pageRoute(settings, const ExamplePage());
    }
  }

  static PageRoute<T> _pageRoute<T>(RouteSettings settings, Widget page) {
    return AppPageRoute<T>(builder: (_) => page, settings: settings);
  }
}
