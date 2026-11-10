import 'package:flutter/widgets.dart';

/// Web 和其他没有 dart:io 的平台不渲染本地文件。
Widget buildLocalFileImage({
  required String path,
  double? width,
  double? height,
  BoxFit? fit,
  required Widget errorWidget,
}) {
  return errorWidget;
}
