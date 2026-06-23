import 'package:flutter/material.dart';

///表单数据模型
class FormViewState {
  List<FormFieldViewState> items;
  Color? backgroundColor;
  BorderRadius? radius;
  EdgeInsets? margin;
  EdgeInsets? itemPadding;
  double height;
  TextStyle? labelStyle;
  TextStyle? descStyle;

  FormViewState({
    required this.height,
    required this.items,
    this.backgroundColor,
    this.radius,
    this.margin,
    this.itemPadding,
    this.labelStyle,
    this.descStyle,
  });
}

class FormFieldViewState {
  String label;
  String? desc;
  Widget? labelExtendWidget;
  Widget? latterWidget;
  Color? backgroundColor;
  EdgeInsets? padding;
  BorderRadius? radius;
  TextStyle? labelStyle;
  TextStyle? descStyle;
  double? height;

  FormFieldViewState({
    required this.label,
    this.labelExtendWidget,
    this.desc,
    this.latterWidget,
    this.backgroundColor,
    this.radius,
    this.labelStyle,
    this.descStyle,
    this.padding,
    this.height,
  });
}
