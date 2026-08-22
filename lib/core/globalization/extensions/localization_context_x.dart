import 'package:flutter/widgets.dart';

import '../generated/app_localizations.dart';

/// BuildContext 本地化快捷访问。
extension LocalizationContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// 某些底层组件需要安全判断 Localizations 是否已挂载。
  AppLocalizations? get maybeL10n {
    return Localizations.of<AppLocalizations>(this, AppLocalizations);
  }
}
