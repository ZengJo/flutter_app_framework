import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///用户输入框
///{value}默认输入框的内容
///{controller}输入控制器，用于控制，获取输入值
///{keyboardType}键盘类型输入类型，如：phone，text
///{readOnly}是否可以输入
///{obscure}密码类型显示*****
///{hint}输入提示内容
///{hintStyle}输入提示内容文字样式
///{textColor}文字颜色
///{fontSize}文字大小
///{errorText}异常提示文本
///{onSaved}输入内容监听
///{border}边框
///{constraints}可设置尺寸
///{margin}外边距
///{padding}内边距
///{contentPadding}内容内边距
///{textAlign}文本对齐方式
///{isCollapsed}包裹内容
///{autofocus}自动聚焦
///{minLines}最小输入行数
///{maxLines}最大输入行数
///{focusNode}光标控制，可以隐藏键盘
///{textInputAction}键盘右下角按钮控制，例如：回车，确认
///{onFieldSubmitted}键盘右下角按钮控制，确认，下一步回调，带参数
///{formatter}约束或格式化用户输入内容。限制字符范围，限制输入长度
///{onEditingComplete}键盘右下角按钮控制，确认，下一步回调，不带参数
class AppTextField extends StatefulWidget {
  final String? value;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? obscure;
  final String? hint;
  final TextStyle? hintStyle;
  final Color? textColor;
  final double? fontSize;
  final String? errorText;
  final FormFieldSetter<String>? onSaved;
  final dynamic border;
  final BoxConstraints? constraints;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final TextAlign? textAlign;
  final bool? isCollapsed;
  final bool? autofocus;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? formatter;
  final VoidCallback? onEditingComplete;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  /// 新增属性
  final int? finishLength; // 监听输入长度
  final Duration debounceDuration; // 停顿检测时间
  final ValueChanged<String>? onFinished; // 输入完成回调

  const AppTextField({
    super.key,
    this.value,
    this.controller,
    this.keyboardType,
    this.readOnly,
    this.obscure,
    this.textColor,
    this.hint,
    this.hintStyle,
    this.fontSize,
    this.errorText,
    this.onSaved,
    this.border,
    this.constraints,
    this.margin,
    this.padding,
    this.contentPadding,
    this.textAlign,
    this.isCollapsed,
    this.autofocus,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.formatter,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.finishLength,
    this.debounceDuration = const Duration(seconds: 1),
    this.onFinished,
    this.scrollPhysics,
    this.scrollController,
    this.maxLength,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _controller =
        widget.controller ?? TextEditingController(text: widget.value ?? '');
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleTextChange() {
    final text = _controller.text;

    // 1. 输入长度达到指定值
    if (widget.finishLength != null && text.length == widget.finishLength) {
      if (text.isNotEmpty) {
        widget.onFinished?.call(text);
      }
      return;
    }

    // 2. 用户输入停顿（防抖）
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      // if (text.isNotEmpty) {
      widget.onFinished?.call(text);
      // }
    });
  }

  void _handleFocusChange() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      // 3. 失去焦点
      if (!_focusNode.hasFocus) {
        widget.onFinished?.call(_controller.text);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      margin: widget.margin ?? EdgeInsets.zero,
      padding: widget.padding ?? EdgeInsets.zero,
      child: FocusTraversalGroup(
        child: TextFormField(
          maxLength: widget.maxLength,
          buildCounter:
              (
                BuildContext context, {
                int? currentLength,
                int? maxLength,
                bool isFocused = false,
              }) {
                return SizedBox.shrink();
              },
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          controller: _controller,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.maxLines == null ? null : widget.minLines,
          focusNode: _focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          autofocus: widget.autofocus ?? false,
          style: TextStyle(
            fontSize: widget.fontSize ?? 14.sp,
            color: widget.textColor ?? Colors.black,
          ),
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          obscureText: widget.obscure ?? false,
          textAlign: widget.textAlign ?? TextAlign.start,
          readOnly: widget.readOnly ?? false,
          scrollPadding: EdgeInsets.zero,
          decoration: InputDecoration(
            hintStyle:
                widget.hintStyle ??
                TextStyle(
                  color: Colors.black.withAlpha(80),
                  fontSize: widget.fontSize ?? 14.sp,
                ),
            hintText: widget.hint,
            isCollapsed: widget.isCollapsed ?? false,
            contentPadding: widget.contentPadding,
            focusedBorder: widget.border == null
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  )
                : null,
            enabledBorder: widget.border == null
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  )
                : null,
            border: widget.border ?? InputBorder.none,
          ),
          inputFormatters: widget.formatter,
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
