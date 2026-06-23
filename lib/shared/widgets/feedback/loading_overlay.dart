import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Global loading overlay based on flutter_easyloading.
class LoadingOverlay {
  static LoadingOverlay? _instance;

  static LoadingOverlay get instance => _resolve();

  static dynamic _status = EasyLoadingStatus.dismiss;

  static LoadingOverlay _resolve() {
    _instance ??= LoadingOverlay();
    EasyLoading.instance.radius = 20.r;
    EasyLoading.instance.backgroundColor = Colors.black;
    // EasyLoading.instance.backgroundColor = Colors.transparent;
    EasyLoading.instance.contentPadding = EdgeInsets.zero;
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.addStatusCallback((status) {
      _status = status;
    });
    return _instance!;
  }

  /// Shows the global loading overlay.
  void show({bool? dismissOnTap}) {
    if (_status == EasyLoadingStatus.dismiss) {
      EasyLoading.instance.indicatorWidget = Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        height: 120.r,
        width: 120.r,
        child: const Center(child: CircularProgressIndicator()),
      );
      EasyLoading.show(dismissOnTap: dismissOnTap);
    }
  }

  /// Dismisses the global loading overlay.
  void dismiss({Duration? duration}) {
    Future.delayed(duration ?? const Duration(milliseconds: 500)).then((value) {
      EasyLoading.dismiss();
    });
  }
}
