import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用文本组件。
///
/// Globalization 注意事项：
/// - 不再强制 Android 使用 SourceHanSansSC，否则阿拉伯语等字符可能缺字。
/// - 默认使用 Theme / 系统字体，让不同语言由系统选择合适字体 fallback。
/// - 对齐默认使用 TextAlign.start，自动兼容 LTR / RTL。
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.color,
    this.align,
    this.lineHeight,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.decorationStyle,
    this.decorationColor,
    this.shadows,
    this.foreground,
    this.letterSpacing,
    this.wordSpacing,
    this.textWidthBasis,
    this.softWrap = true,
  });

  final String? text;
  final TextStyle? style;
  final double? fontSize;
  final double? lineHeight;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final TextDecorationStyle? decorationStyle;
  final Color? decorationColor;
  final List<Shadow>? shadows;
  final Paint? foreground;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextWidthBasis? textWidthBasis;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.longestLine,
      style:
          style ??
          TextStyle(
            fontSize: fontSize ?? 14.sp,
            height: lineHeight,
            decoration: decoration ?? TextDecoration.none,
            decorationStyle: decorationStyle,
            decorationColor: decorationColor,
            fontWeight: fontWeight ?? FontWeight.w400,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            fontFamily: fontFamily,
            color: foreground == null
                ? color ?? const Color(0xFF222222)
                : null,
            shadows: shadows,
            foreground: foreground,
          ),
    );
  }
}
