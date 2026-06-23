import 'package:flutter/material.dart';

///所有点击事件父类(CustomButtonWidget除外)
///{onTap}事件点击
///{child}子类widget
///{behavior}点击范围
///{onDoubleTap}双击事件
///{onLongPressStart}长按开始
///{onLongPressEnd}长按结束
/// {enableThrottle}是否启用节流
/// {throttleInterval}节流时间（毫秒）
/// 所有点击事件父类(CustomButtonWidget除外)
class AppTapArea extends StatefulWidget {
  const AppTapArea({
    super.key,
    this.onTap,
    required this.child,
    this.behavior,
    this.onDoubleTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onPanUpdate,
    this.enableThrottle = true,
    this.throttleInterval = 200,
  });

  /// {onTap}点击事件
  final VoidCallback? onTap;

  /// {child}子组件
  final Widget child;

  /// {behavior}点击范围
  final HitTestBehavior? behavior;

  /// {onDoubleTap}双击事件
  final GestureTapCallback? onDoubleTap;

  /// {onLongPressStart}长按开始
  final GestureLongPressStartCallback? onLongPressStart;

  /// {onLongPressEnd}长按结束
  final GestureLongPressEndCallback? onLongPressEnd;

  /// {onTapDown}点击按下事件
  final GestureTapDownCallback? onTapDown;

  /// {onTapUp}点击抬起事件
  final GestureTapUpCallback? onTapUp;

  /// {onTapCancel}点击取消事件
  final GestureTapCancelCallback? onTapCancel;

  /// {onPanUpdate}拖动事件
  final GestureDragUpdateCallback? onPanUpdate;

  /// {enableThrottle}是否启用节流
  final bool enableThrottle;

  /// {throttleInterval}节流时间（毫秒）
  final int throttleInterval;

  @override
  State<AppTapArea> createState() => _AppTapAreaState();
}

class _AppTapAreaState extends State<AppTapArea> {
  DateTime? _lastTapTime;

  bool _preventDoubleTap() {
    if (!widget.enableThrottle) return true;

    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) >
            Duration(milliseconds: widget.throttleInterval)) {
      _lastTapTime = now;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior ?? HitTestBehavior.opaque,
      onTapCancel: widget.onTapCancel,
      onPanUpdate: widget.onPanUpdate,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onDoubleTap: widget.onDoubleTap,
      onLongPressStart: widget.onLongPressStart,
      onLongPressEnd: widget.onLongPressEnd,
      onTap: () {
        if (widget.onTap == null) return;
        if (_preventDoubleTap()) {
          widget.onTap?.call();
        }
      },
      child: widget.child,
    );
  }
}
