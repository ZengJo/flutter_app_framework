import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocStateMixin<T extends StatefulWidget> on State<T> {
  /// 通用：读取任何 Bloc 的值，不监听
  B readBloc<B extends StateStreamableSource<Object?>>() {
    return context.read<B>();
  }

  /// 通用：读取任何 Bloc 的状态
  S readState<B extends StateStreamableSource<S>, S>() {
    return context.read<B>().state;
  }

  /// 通用：监听任何 Bloc 的状态
  S watchState<B extends StateStreamableSource<S>, S>() {
    return context.watch<B>().state;
  }

  /// 通用：选择性监听 Bloc 的部分状态
  R selectBlocState<B extends StateStreamableSource<S>, S, R>(
    R Function(S state) selector,
  ) {
    return context.select<B, R>((bloc) => selector(bloc.state));
  }
}
