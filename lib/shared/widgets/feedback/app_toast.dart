import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/config/app_globals.dart';
import '../../../core/device/device_info_service.dart';
import '../../../core/globalization/generated/app_localizations.dart';
import '../text/app_text.dart';

class AppToast {
  static OverlayEntry? _entry;
  static Timer? _timer;

  /// 从异常对象中提取适合展示给用户的文案。
  ///
  /// 框架自身可识别的错误使用 ARB；业务异常仍保留异常自身 message。
  static String messageOf(Object? error, {BuildContext? context}) {
    final l10n = _maybeL10n(context ?? maybeGlobalContext);

    if (error == null) {
      return l10n?.commonUnknownError ?? 'Unknown error';
    }

    if (error is FormatException) {
      return error.message;
    }

    if (error is TimeoutException) {
      final message = error.message;
      if (message != null && message.trim().isNotEmpty) return message;
      return l10n?.commonRequestTimeout ?? 'Request timed out';
    }

    // 去掉一层或多层 Dart 默认的 `Exception: ` 前缀。
    var value = error.toString().trim();
    const prefix = 'Exception: ';
    while (value.startsWith(prefix)) {
      value = value.substring(prefix.length).trimLeft();
    }

    return value.isEmpty ? l10n?.commonUnknownError ?? 'Unknown error' : value;
  }

  static void showError(
    Object error, {
    Duration duration = const Duration(seconds: 2),
  }) {
    show(messageOf(error), duration: duration);
  }

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _dismiss();

    final context = maybeGlobalContext;
    if (context == null) return;

    final overlay = Overlay.of(context, rootOverlay: true);
    _entry = OverlayEntry(builder: (_) => _ToastWidget(message: message));
    overlay.insert(_entry!);

    _timer = Timer(duration, _dismiss);
  }

  static AppLocalizations? _maybeL10n(BuildContext? context) {
    if (context == null) return null;
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;

    try {
      _entry?.remove();
    } catch (_) {
      // 忽略重复 remove。
    }

    _entry = null;
  }
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      child: IgnorePointer(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: DeviceInfoService.screenWidth(context) * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
