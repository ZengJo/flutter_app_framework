import 'package:flutter/widgets.dart';

import 'app_asset.dart';

/// 图片资源最终解析结果。
///
/// [path]
/// 最终需要加载的图片路径。
///
/// [matchTextDirection]
/// 是否由 Flutter 根据当前 TextDirection 自动水平镜像。
class ResolvedAppAsset {
  const ResolvedAppAsset({required this.path, this.matchTextDirection = false});

  final String path;

  final bool matchTextDirection;
}

/// 全球化图片资源解析器。
///
/// 统一负责：
///
/// - 普通资源
/// - RTL 自动镜像
/// - LTR / RTL 独立资源
/// - Locale 独立资源
///
/// 业务页面不应该直接判断当前语言。
class AppAssetResolver {
  const AppAssetResolver._();

  /// 根据当前 BuildContext 解析最终图片资源。
  static ResolvedAppAsset resolve(BuildContext context, AppAsset asset) {
    switch (asset.strategy) {
      case AppAssetStrategy.fixed:
        return _resolveFixed(asset);

      case AppAssetStrategy.mirrorOnRtl:
        return _resolveMirror(asset);

      case AppAssetStrategy.directional:
        return _resolveDirectional(context, asset);

      case AppAssetStrategy.localized:
        return _resolveLocalized(context, asset);
    }
  }

  /// 普通固定图片。
  static ResolvedAppAsset _resolveFixed(AppAsset asset) {
    return ResolvedAppAsset(path: asset.path ?? '');
  }

  /// 可自动镜像图片。
  ///
  /// 这里不需要自己判断 RTL。
  ///
  /// matchTextDirection = true 后，
  /// Flutter 会根据 Directionality 自动决定是否翻转。
  static ResolvedAppAsset _resolveMirror(AppAsset asset) {
    return ResolvedAppAsset(path: asset.path ?? '', matchTextDirection: true);
  }

  /// LTR / RTL 独立资源。
  static ResolvedAppAsset _resolveDirectional(
    BuildContext context,
    AppAsset asset,
  ) {
    final textDirection = Directionality.of(context);

    final isRtl = textDirection == TextDirection.rtl;

    return ResolvedAppAsset(
      path: isRtl
          ? asset.rtlPath ?? asset.ltrPath ?? ''
          : asset.ltrPath ?? asset.rtlPath ?? '',
    );
  }

  /// 根据当前 Locale 选择对应语言图片。
  static ResolvedAppAsset _resolveLocalized(
    BuildContext context,
    AppAsset asset,
  ) {
    final locale = Localizations.localeOf(context);

    final path = _resolveLocalizedPath(locale, asset.localizedPaths);

    return ResolvedAppAsset(path: path ?? asset.fallbackPath ?? '');
  }

  /// 按照从“最精确”到“最宽泛”的规则匹配资源。
  ///
  /// 例如当前：
  ///
  /// zh-Hans-CN
  ///
  /// 会依次查找：
  ///
  /// 1. zh-Hans-CN
  /// 2. zh-Hans
  /// 3. zh
  static String? _resolveLocalizedPath(
    Locale locale,
    Map<String, String> paths,
  ) {
    if (paths.isEmpty) {
      return null;
    }

    /// 做一次标准化。
    ///
    /// 避免：
    ///
    /// zh-Hans
    /// zh-hans
    /// ZH-HANS
    ///
    /// 因大小写问题匹配失败。
    final normalizedPaths = <String, String>{};

    for (final entry in paths.entries) {
      normalizedPaths[_normalizeLanguageTag(entry.key)] = entry.value;
    }

    final candidates = _buildLocaleCandidates(locale);

    for (final candidate in candidates) {
      final path = normalizedPaths[_normalizeLanguageTag(candidate)];

      if (path != null && path.isNotEmpty) {
        return path;
      }
    }

    return null;
  }

  /// 生成 Locale 匹配候选列表。
  static List<String> _buildLocaleCandidates(Locale locale) {
    final result = <String>[];

    /// 最完整：
    ///
    /// zh-Hans-CN
    /// en-US
    /// ar-SA
    final fullTag = locale.toLanguageTag();

    if (fullTag.isNotEmpty) {
      result.add(fullTag);
    }

    /// language + script
    ///
    /// 例如：
    ///
    /// zh-Hans
    if (locale.scriptCode != null && locale.scriptCode!.isNotEmpty) {
      result.add('${locale.languageCode}-${locale.scriptCode}');
    }

    /// language + country
    ///
    /// 例如：
    ///
    /// en-US
    /// ar-SA
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      result.add('${locale.languageCode}-${locale.countryCode}');
    }

    /// 最后降级到语言。
    ///
    /// en
    /// zh
    /// ar
    result.add(locale.languageCode);
    return result.toSet().toList();
  }

  /// 统一语言标签格式用于比较。
  static String _normalizeLanguageTag(String value) {
    return value.trim().replaceAll('_', '-').toLowerCase();
  }
}
