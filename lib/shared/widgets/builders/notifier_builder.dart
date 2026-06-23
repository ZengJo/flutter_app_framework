import 'package:flutter/material.dart';

class NotifierBuilder<T> extends StatelessWidget {
  final ValueNotifier<T> notifier;
  final Widget Function(BuildContext context, T value) builder;

  const NotifierBuilder({
    super.key,
    required this.notifier,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return builder(context, value);
      },
    );
  }
}
