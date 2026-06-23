import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/gestures/app_tap_area.dart';
import '../../widgets/text/app_text.dart';
import '../state/form_field_state.dart';

///自定义表单
class AppForm extends StatelessWidget {
  ///表单数据
  final FormViewState formState;

  ///边框设置
  final BoxBorder? border;

  ///点击事件
  final Function(int index)? onItemTap;

  ///默认标题文案字体样式
  final TextStyle? defaultLabelStyle;

  ///默认描述文案字体样式
  final TextStyle? defaultDescStyle;

  /// 是否开启高斯模糊
  final bool enableBlur;

  /// 模糊程度
  final double blurAmount;

  /// 是否使用渐变分隔线
  final bool useGradientDivider;

  const AppForm({
    super.key,
    required this.formState,
    this.border,
    this.onItemTap,
    this.defaultLabelStyle,
    this.defaultDescStyle,
    this.enableBlur = false,
    this.blurAmount = 5.0,
    this.useGradientDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: formState.margin,
      decoration: BoxDecoration(
        border:
            border ?? Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: formState.radius,
        color: formState.backgroundColor,
      ),
      child: Column(
        children: formState.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          // 获取最终的文本样式（优先级：item样式 > formState样式 > 默认样式）
          final labelStyle =
              item.labelStyle ?? formState.labelStyle ?? defaultLabelStyle;
          final descStyle =
              item.descStyle ?? formState.descStyle ?? defaultDescStyle;

          return AppTapArea(
            onTap: () => onItemTap?.call(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Container(
                  padding: item.padding ?? formState.itemPadding,
                  height: item.height ?? formState.height,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              item.label,
                              align: TextAlign.start,
                              fontSize: labelStyle?.fontSize,
                              fontWeight: labelStyle?.fontWeight,
                              color: labelStyle?.color,
                            ),
                            if (item.labelExtendWidget != null)
                              item.labelExtendWidget ?? SizedBox.shrink(),
                          ],
                        ),
                      ),

                      // 描述区域：优先显示 descWidget，如果没有则显示 desc 文本
                      if (item.desc != null)
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(left: 16.r),
                            margin: EdgeInsets.only(right: 4.r),
                            child: AppText(
                              item.desc,
                              fontSize: descStyle?.fontSize,
                              fontWeight: descStyle?.fontWeight,
                              maxLines: 1,
                              color: descStyle?.color ?? Color(0xFF999999),
                            ),
                          ),
                        ),
                      // 右侧 widget
                      item.latterWidget ?? SizedBox.shrink(),
                    ],
                  ),
                ),
                // 分隔线
                if (index < formState.items.length - 1)
                  useGradientDivider
                      ? Container(
                          height: 0.5,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFFF0F0F0).withValues(
                                  alpha: 0.00,
                                ), // rgba(240, 240, 240, 0.00)
                                const Color(0xFFE5E5E5).withValues(
                                  alpha: 0.30,
                                ), // rgba(229, 229, 229, 0.30)
                                const Color(0xFFF0F0F0).withValues(
                                  alpha: 0.00,
                                ), // rgba(240, 240, 240, 0.00)
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        )
                      : Container(
                          height: 0.5,
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
              ],
            ),
          );
        }).toList(),
      ),
    );

    // 如果开启高斯模糊，则包装在 BackdropFilter 中
    if (enableBlur) {
      return ClipRRect(
        borderRadius: formState.radius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: content,
        ),
      );
    }

    return content;
  }
}
