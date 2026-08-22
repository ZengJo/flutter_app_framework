import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Globalization 当前信息列表项。
///
/// 用于展示：
/// - 当前语言
/// - Locale
/// - API Language
/// - 地区
/// - 货币
/// - 时区
/// - 单位制
/// - 12 / 24 小时制
/// - LTR / RTL
///
/// 布局全部使用 start / end 语义，自动兼容 Arabic 等 RTL 语言。
class GlobalizationInfoTile extends StatelessWidget {
  const GlobalizationInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.showDivider = true,
  });

  /// 左侧 / RTL 下右侧图标。
  final IconData icon;

  /// 信息名称。
  final String title;

  /// 当前真正生效的值。
  final String value;

  /// 配置来源，例如：
  /// - 跟随系统
  /// - 跟随地区
  /// - 手动设置
  final String? subtitle;

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            16.w,
            13.h,
            16.w,
            13.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),

              /// 标题 + 来源。
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.3,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12.w),

              /// 当前真正生效值。
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 66.w,
              end: 16.w,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
      ],
    );
  }
}
