import 'dart:io';

import 'package:flutter/widgets.dart';

/// 移动端和桌面端使用本地文件渲染图片。
Widget buildLocalFileImage({
  required String path,
  double? width,
  double? height,
  BoxFit? fit,
  required Widget errorWidget,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    gaplessPlayback: true,
    errorBuilder: (context, error, stackTrace) => errorWidget,
  );
}
