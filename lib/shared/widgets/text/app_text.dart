import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///文本组件
///{text}文本内容
///{style}样式
///{fontSize}文字大小
///{fontWeight}字重
///{fontFamily}字体
///{color}颜色
///{align}对齐方式
///{lineHeight}行高
///{maxLines}最大显示行数
///{overflow}文字溢出时的显示方式
///{decoration}外观样式 —— 比如颜色、圆角、边框、阴影、渐变、图片等。
///{decorationStyle}下划线、删除线、上划线，等线条的样式
///{decorationColor}下划线、删除线、上划线，等线条的样式，颜色
///{shadows}阴影效果（模糊、偏移、颜色等）
///{foreground}绘制方式，渐变颜色、描边效果
///{textWidthBasis}文本宽度基础
class AppText extends StatefulWidget {
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
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text ?? '默认文本',
      textAlign: widget.align ?? TextAlign.start,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.longestLine,
      style:
          widget.style ??
          TextStyle(
            fontSize: widget.fontSize ?? 14.sp,
            height: widget.lineHeight,
            decoration: widget.decoration ?? TextDecoration.none,
            decorationStyle: widget.decorationStyle,
            decorationColor: widget.decorationColor,
            fontWeight: widget.fontWeight ?? FontWeight.w400,
            letterSpacing: widget.letterSpacing,
            wordSpacing: widget.wordSpacing,
            fontFamily:
                widget.fontFamily ??
                (Platform.isAndroid ? 'SourceHanSansSC' : ''),
            color: widget.foreground == null
                ? widget.color ?? const Color(0xFF222222)
                : null,
            shadows: widget.shadows,
            foreground: widget.foreground,
          ),
    );
  }
}
