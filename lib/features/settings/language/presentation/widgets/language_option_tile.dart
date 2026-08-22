import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 语言选择页中的单个语言选项。
///
/// 组件内部全部使用 Directional / start / end 语义，
/// 因此：
/// - 中文、英文：LTR，从左向右；
/// - 阿拉伯语：RTL，从右向左；
/// 不需要任何 isArabic 判断。
class LanguageOptionTile extends StatelessWidget {
  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.badgeText,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.systemOption = false,
    this.showDivider = true,
  });

  /// 主标题，例如 English / 简体中文 / العربية。
  final String title;

  /// 副标题，例如当前 UI 语言下的“英语 / 阿拉伯语”。
  final String? subtitle;

  /// 左/右侧圆形标识中的文字。
  final String badgeText;

  /// 当前是否选中。
  final bool selected;

  /// 是否为“跟随系统”选项。
  final bool systemOption;

  /// 是否显示底部分割线。
  final bool showDivider;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                16.w,
                14.h,
                16.w,
                14.h,
              ),
              child: Row(
                children: [
                  /// 语言图标/标识。
                  Container(
                    width: 42.w,
                    height: 42.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primary.withValues(alpha: 0.10)
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.55,
                            ),
                      shape: BoxShape.circle,
                    ),
                    child: systemOption
                        ? Icon(
                            Icons.language_rounded,
                            size: 22.sp,
                            color: selected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          )
                        : Text(
                            badgeText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: badgeText.length > 1 ? 12.sp : 17.sp,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                  ),
                  SizedBox(width: 12.w),

                  /// 文案区域。
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 1.25,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 13.sp,
                              height: 1.35,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  /// 选中状态。
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey<String>('selected'),
                            size: 24.sp,
                            color: colorScheme.primary,
                          )
                        : Icon(
                            Icons.radio_button_unchecked_rounded,
                            key: const ValueKey<String>('unselected'),
                            size: 24.sp,
                            color: colorScheme.outlineVariant,
                          ),
                  ),
                ],
              ),
            ),
            if (showDivider)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 70.w,
                  end: 16.w,
                ),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
