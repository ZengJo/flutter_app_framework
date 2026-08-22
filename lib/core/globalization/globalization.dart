/// Globalization 模块对业务层的统一出口。
///
/// 新业务页面优先只导入这个文件，避免依赖 Globalization 内部目录结构。
library;

export 'extensions/localization_context_x.dart';
export 'formatter/app_currency_formatter.dart';
export 'formatter/app_date_formatter.dart';
export 'formatter/app_number_formatter.dart';
export 'formatter/app_unit_formatter.dart';
export 'generated/app_localizations.dart';
export 'model/app_hour_cycle.dart';
export 'model/app_language.dart';
export 'model/globalization_preferences.dart';
export 'model/globalization_state.dart';
export 'model/measurement_system.dart';
export 'providers/globalization_providers.dart';
export 'system/globalization_system_service.dart';
