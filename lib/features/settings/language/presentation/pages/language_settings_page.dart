import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/globalization/extensions/localization_context_x.dart';
import '../../../../../core/globalization/model/app_hour_cycle.dart';
import '../../../../../core/globalization/model/app_language.dart';
import '../../../../../core/globalization/model/measurement_system.dart';
import '../../../../../core/globalization/providers/globalization_providers.dart';
import '../../model/app_language_display_x.dart';
import '../../providers/language_settings_provider.dart';
import '../widgets/globalization_info_tile.dart';
import '../widgets/language_option_tile.dart';

/// 语言 / Globalization 设置页面。
///
/// 页面分为两部分：
///
/// 1. Language：
///    - 跟随系统；
///    - English；
///    - 简体中文；
///    - العربية；
///
/// 2. Current Globalization：
///    - 当前语言；
///    - Locale；
///    - API Language；
///    - 地区；
///    - 货币；
///    - 时区；
///    - 单位制；
///    - 12 / 24 小时制；
///    - LTR / RTL。
///
/// 当前页面只展示 Globalization 其它配置，
/// 修改地区 / 货币 / 时区等能力仍然统一由 GlobalizationController 提供，
/// 后续可以继续为这些条目增加独立选择页面。
class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(languageSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        /// 使用 Flutter 系统 BackButton，自动兼容 LTR / RTL。
        leading: const BackButton(),
        title: Text(
          l10n.languagePageTitle,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
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
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 20.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =========================
              /// Language
              /// =========================
              _buildSectionTitle(context, l10n.globalizationLanguage),
              SizedBox(height: 6.h),
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
              SizedBox(height: 14.h),
              _buildLanguageCard(
                context: context,
                ref: ref,
                settings: settings,
              ),
              SizedBox(height: 24.h),

              /// =========================
              /// Current Globalization
              /// =========================
              _buildSectionTitle(
                context,
                l10n.globalizationCurrentConfiguration,
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                child: Text(
                  l10n.globalizationCurrentConfigurationDescription,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.45,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              _buildGlobalizationInfoCard(context: context, settings: settings),
              SizedBox(height: 16.h),

              /// 切换语言说明。
              _buildHintCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 模块标题。
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16.sp,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  /// 语言切换卡片。
  Widget _buildLanguageCard({
    required BuildContext context,
    required WidgetRef ref,
    required LanguageSettingsState settings,
  }) {
    final l10n = context.l10n;

    return Material(
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
            onTap: () => _changeLanguage(ref, null, settings.isSelected(null)),
          ),

          /// 项目支持语言。
          for (
            var index = 0;
            index < settings.supportedLanguages.length;
            index++
          )
            _buildLanguageItem(
              context: context,
              ref: ref,
              language: settings.supportedLanguages[index],
              selected: settings.isSelected(settings.supportedLanguages[index]),
              showDivider: index != settings.supportedLanguages.length - 1,
            ),
        ],
      ),
    );
  }

  /// 当前 Globalization 信息卡片。
  ///
  /// 这里展示 GlobalizationState 当前已经存在的全部主要字段。
  Widget _buildGlobalizationInfoCard({
    required BuildContext context,
    required LanguageSettingsState settings,
  }) {
    final l10n = context.l10n;
    final state = settings.globalization;
    final preferences = settings.preferences;

    final measurementText = switch (state.measurementSystem) {
      MeasurementSystem.metric => l10n.globalizationMetric,
      MeasurementSystem.imperial => l10n.globalizationImperial,
      MeasurementSystem.system => l10n.commonSystemDefault,
    };

    final hourCycleText = switch (state.hourCycle) {
      AppHourCycle.h12 => l10n.globalization12Hour,
      AppHourCycle.h24 => l10n.globalization24Hour,
      AppHourCycle.system => l10n.commonSystemDefault,
    };

    final textDirectionText = state.isRtl
        ? l10n.globalizationRtl
        : l10n.globalizationLtr;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          /// 当前实际语言。
          GlobalizationInfoTile(
            icon: Icons.translate_rounded,
            title: l10n.globalizationLanguage,
            value: state.language.nativeName,
            subtitle: preferences.followSystemLanguage
                ? l10n.commonFollowSystem
                : l10n.globalizationManual,
          ),

          /// Flutter 当前 Locale。
          GlobalizationInfoTile(
            icon: Icons.public_rounded,
            title: l10n.globalizationLocale,
            value: state.locale.toLanguageTag(),
          ),

          /// 发给服务端的语言码。
          GlobalizationInfoTile(
            icon: Icons.api_rounded,
            title: l10n.globalizationApiLanguage,
            value: state.apiLanguageCode,
          ),

          /// 当前地区。
          GlobalizationInfoTile(
            icon: Icons.location_on_outlined,
            title: l10n.globalizationRegion,
            value: state.regionCode,
            subtitle: preferences.followSystemRegion
                ? l10n.commonFollowSystem
                : l10n.globalizationManual,
          ),

          /// 当前货币。
          GlobalizationInfoTile(
            icon: Icons.payments_outlined,
            title: l10n.globalizationCurrency,
            value: state.currencyCode,
            subtitle: preferences.followRegionCurrency
                ? l10n.globalizationFollowRegion
                : l10n.globalizationManual,
          ),

          /// 当前 IANA Time Zone。
          GlobalizationInfoTile(
            icon: Icons.schedule_rounded,
            title: l10n.globalizationTimeZone,
            value: state.timeZoneId,
            subtitle: preferences.followSystemTimeZone
                ? l10n.commonFollowSystem
                : l10n.globalizationManual,
          ),

          /// 当前真正生效的单位制。
          GlobalizationInfoTile(
            icon: Icons.straighten_rounded,
            title: l10n.globalizationUnits,
            value: measurementText,
            subtitle: preferences.measurementSystem == MeasurementSystem.system
                ? l10n.globalizationFollowRegion
                : l10n.globalizationManual,
          ),

          /// 当前真正生效的 12 / 24 小时制。
          GlobalizationInfoTile(
            icon: Icons.access_time_rounded,
            title: l10n.globalizationTimeFormat,
            value: hourCycleText,
            subtitle: preferences.hourCycle == AppHourCycle.system
                ? l10n.commonFollowSystem
                : l10n.globalizationManual,
          ),

          /// 当前文字方向。
          GlobalizationInfoTile(
            icon: state.isRtl
                ? Icons.format_textdirection_r_to_l_rounded
                : Icons.format_textdirection_l_to_r_rounded,
            title: l10n.globalizationTextDirection,
            value: textDirectionText,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  /// 底部说明卡片。
  Widget _buildHintCard(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.sp,
            color: colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              l10n.languageChangeImmediatelyHint,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.45,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
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
    final nativeName = language.nativeName;

    /// 如果翻译名称与原生名称相同，则不重复显示副标题。
    final subtitle =
        localizedName.trim().toLowerCase() == nativeName.trim().toLowerCase()
        ? null
        : localizedName;

    return LanguageOptionTile(
      title: nativeName,
      subtitle: subtitle,
      badgeText: language.badgeText,
      selected: selected,
      showDivider: showDivider,
      onTap: () => _changeLanguage(ref, language, selected),
    );
  }

  /// 执行语言切换。
  ///
  /// GlobalizationController 内部统一负责：
  /// - Preferences 更新；
  /// - GlobalizationState 重新解析；
  /// - MaterialApp Locale 更新；
  /// - LTR / RTL 更新；
  /// - 本地持久化；
  /// - 后续网络请求 Header 更新。
  Future<void> _changeLanguage(
    WidgetRef ref,
    AppLanguage? language,
    bool alreadySelected,
  ) async {
    if (alreadySelected) return;

    await ref.read(globalizationProvider.notifier).setLanguage(language);
  }
}
