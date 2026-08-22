/// Globalization 模块对业务层的统一出口。
///
/// 新业务页面优先只导入这个文件，
/// 避免依赖 Globalization 内部目录结构。
library;

/// 全球化图片资源。
export 'assets/app_asset.dart';
export 'assets/app_asset_resolver.dart';

/// Context 扩展。
export 'extensions/localization_context_x.dart';

/// 格式化。
export 'formatter/app_currency_formatter.dart';
export 'formatter/app_date_formatter.dart';
export 'formatter/app_number_formatter.dart';
export 'formatter/app_unit_formatter.dart';

/// Flutter gen_l10n 自动生成。
export 'generated/app_localizations.dart';

/// Model。
export 'model/app_hour_cycle.dart';
export 'model/app_language.dart';
export 'model/globalization_preferences.dart';
export 'model/globalization_state.dart';
export 'model/measurement_system.dart';

/// Riverpod Provider。
export 'providers/globalization_providers.dart';

/// System。
export 'system/globalization_system_service.dart';
