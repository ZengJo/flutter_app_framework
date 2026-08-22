import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/globalization/extensions/localization_context_x.dart';
import '../../../../../core/globalization/model/app_language.dart';
import '../../../../../core/globalization/providers/globalization_providers.dart';
import '../../model/app_language_display_x.dart';
import '../../providers/language_settings_provider.dart';
import '../widgets/language_option_tile.dart';

/// 语言切换页面。
///
/// 功能：
/// 1. 跟随系统语言；
/// 2. 显示项目当前支持的全部语言；
/// 3. 显示当前选中语言；
/// 4. 切换后立即刷新整个 App；
/// 5. Arabic 切换后当前页面立即变为 RTL；
/// 6. 选择结果由 GlobalizationController 自动持久化。
class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(languageSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        /// 使用系统 BackButton。
        /// Flutter 会根据 Directionality 正确处理 LTR / RTL。
        leading: const BackButton(),
        title: Text(
          l10n.languagePageTitle,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.fromSTEB(
            16.w,
            20.h,
            16.w,
            28.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 页面说明。
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                child: Text(
                  l10n.languagePageDescription,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              /// 语言列表卡片。
              Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    /// 跟随系统。
                    LanguageOptionTile(
                      title: l10n.commonFollowSystem,
                      subtitle: l10n.languageSystemCurrent(
                        settings.systemLanguage.nativeName,
                      ),
                      badgeText: '',
                      systemOption: true,
                      selected: settings.isSelected(null),
                      onTap: () => _changeLanguage(
                        ref,
                        null,
                        settings.isSelected(null),
                      ),
                    ),

                    /// 项目支持的语言。
                    for (var index = 0;
                        index < settings.supportedLanguages.length;
                        index++)
                      _buildLanguageItem(
                        context: context,
                        ref: ref,
                        language: settings.supportedLanguages[index],
                        selected: settings.isSelected(
                          settings.supportedLanguages[index],
                        ),
                        showDivider:
                            index != settings.supportedLanguages.length - 1,
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              /// 说明区域。
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(
                  14.w,
                  12.h,
                  14.w,
                  12.h,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.40),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        l10n.languageChangeImmediatelyHint,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.45,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建普通语言项。
  Widget _buildLanguageItem({
    required BuildContext context,
    required WidgetRef ref,
    required AppLanguage language,
    required bool selected,
    required bool showDivider,
  }) {
    final l10n = context.l10n;
    final localizedName = language.localizedName(l10n);

    /// 主标题始终优先显示语言自己的名称。
    /// 这样用户即使误切换到陌生语言，也更容易找到自己熟悉的语言。
    final nativeName = language.nativeName;

    /// 如果当前 UI 翻译名称与 nativeName 完全一样，避免重复显示副标题。
    final subtitle = localizedName.trim().toLowerCase() ==
            nativeName.trim().toLowerCase()
        ? null
        : localizedName;

    return LanguageOptionTile(
      title: nativeName,
      subtitle: subtitle,
      badgeText: language.badgeText,
      selected: selected,
      showDivider: showDivider,
      onTap: () => _changeLanguage(
        ref,
        language,
        selected,
      ),
    );
  }

  /// 执行语言切换。
  ///
  /// GlobalizationController 内部会：
  /// 1. 更新 Preferences；
  /// 2. 立即重新计算 GlobalizationState；
  /// 3. 更新 MaterialApp.locale；
  /// 4. 自动刷新 Directionality；
  /// 5. 保存到本地；
  /// 6. 下一次 HTTP 请求自动携带新的语言 Header。
  Future<void> _changeLanguage(
    WidgetRef ref,
    AppLanguage? language,
    bool alreadySelected,
  ) async {
    if (alreadySelected) return;

    await ref.read(globalizationProvider.notifier).setLanguage(language);
  }
}
