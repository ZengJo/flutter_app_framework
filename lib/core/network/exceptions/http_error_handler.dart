import 'package:flutter/widgets.dart';

import '../../../app/config/app_globals.dart';
import '../../../shared/widgets/feedback/app_toast.dart';
import '../../globalization/generated/app_localizations.dart';

/// 处理后端非 200 业务状态码。
///
/// 后端只负责返回稳定 code；框架根据当前 Locale 决定展示语言。
class ResponseErrorHandler {
  const ResponseErrorHandler._();

  /// 返回 true 表示当前 code 已由客户端处理。
  static Future<bool> handle({
    int? code,
    required String serverMsg,
    bool isShowToast = true,
  }) async {
    if (code == null) return false;

    final l10n = _currentL10n();
    final mapped = _messageForCode(code, l10n);
    if (mapped == null || mapped.isEmpty) return false;

    if (isShowToast) AppToast.show(mapped);
    return true;
  }

  static AppLocalizations? _currentL10n() {
    final context = maybeGlobalContext;
    if (context == null) return null;
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String? _messageForCode(int code, AppLocalizations? l10n) {
    if (l10n != null) {
      return switch (code) {
        10001 => l10n.errorParameterMismatch,
        10002 => l10n.errorOperationFailed,
        10003 => l10n.errorJsonParseFailed,
        10004 => l10n.errorMethodValidationFailed,
        10005 => l10n.errorRetryLater,
        10006 => l10n.errorUnknownEventType,
        10016 => l10n.errorFilePathEmpty,
        10017 => l10n.errorFilePathInvalidCharacters,
        10018 => l10n.errorFileNameSuffixRequired,
        10019 => l10n.errorFileSuffixInvalid,
        10020 => l10n.errorFilePathInvalid,
        13001 => l10n.errorPlatformVersionMissing,
        14001 => l10n.errorDataInvalid,
        20001 => l10n.errorLoginFailed,
        20002 => l10n.errorUserNotFound,
        20003 => l10n.errorIncorrectPassword,
        _ => null,
      };
    }

    // 极少数 Localizations 尚未挂载的场景使用英文兜底。
    return switch (code) {
      10001 => 'Invalid request parameters',
      10002 => 'Operation failed',
      10003 => 'Failed to parse JSON',
      10004 => 'Parameter validation failed',
      10005 => 'Please try again later',
      10006 => 'Unknown event type',
      10016 => 'File path cannot be empty',
      10017 => 'File path contains invalid characters',
      10018 => 'The file name must contain a valid extension',
      10019 => 'The file extension must contain 1–10 letters or numbers',
      10020 => 'The file path format is invalid',
      13001 => 'Platform version information is unavailable',
      14001 => 'Invalid data',
      20001 => 'Sign-in failed',
      20002 => 'User not found',
      20003 => 'Incorrect password',
      _ => null,
    };
  }
}
