import 'package:dio/dio.dart';

import '../model/globalization_state.dart';

/// 每次请求实时写入 Globalization Header。
///
/// 不缓存 language / region / currency / timezone，确保用户切换语言后
/// 下一条请求立即使用新配置，也不需要重建 Dio。
class GlobalizationInterceptor extends Interceptor {
  GlobalizationInterceptor({required GlobalizationState Function() readState})
    : _readState = readState;

  final GlobalizationState Function() _readState;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final globalization = _readState();

    options.headers.addAll(globalization.toRequestHeaders());

    handler.next(options);
  }
}
