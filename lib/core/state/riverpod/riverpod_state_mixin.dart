import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

mixin RiverpodStateMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// 通用：读取任何 Provider 的值，不监听
  R readValue<R>(ProviderListenable<R> provider) {
    return ref.read(provider);
  }

  /// 通用：监听任何 Provider 的值
  R watchValue<R>(ProviderListenable<R> provider) {
    return ref.watch(provider);
  }

  /// 通用：读取任何 Provider 的 Notifier
  N readNotifier<N>(ProviderListenable<N> notifierProvider) {
    return ref.read(notifierProvider);
  }

  /// 选择性监听 Provider 的部分字段
  R selectState<P, R>(ProviderBase<P> provider, R Function(P state) selector) {
    return ref.watch(provider.select(selector));
  }
}
