import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../shared/widgets/feedback/app_toast.dart';
import '../../../shared/widgets/feedback/loading_overlay.dart';
import '../../storage/preferences_service.dart';
import '../../storage/storage_keys.dart';
import '../../utils/input_validator.dart';
import '../client/http_client.dart';
import '../exceptions/http_error_handler.dart';
import '../headers/request_headers.dart';
import '../offline_queue/offline_request.dart';
import '../utils/idempotency_key_generator.dart';

const String defaultBaseUrl = 'https://api.ymdq.com';

enum RequestMethod { get, post, put, delete, head, upload }

Future<dynamic> request(
  String url, {
  dynamic params,
  String? baseUrl,
  RequestMethod method = RequestMethod.post,
  String contentType = Headers.jsonContentType,
  ResponseType responseType = ResponseType.json,
  bool authorization = true,
  bool isLoading = true,
  CancelToken? cancelToken,
  Map<String, dynamic>? headers,
  String? idempotencyKey,
  QueuePriority? priority,
  QueueCategory? category,
  bool isShowToast = true,
  bool? isOffline = true,
  ProgressCallback? onSendProgress,
}) async {
  HttpClient.setLoading(isLoading);

  final finalIdempotencyKey =
      idempotencyKey ?? IdempotencyKeyGenerator.generate();
  final finalPriority = priority ?? _defaultPriority(method);
  final finalCategory = category ?? _defaultCategory(method);

  final options = Options(
    contentType: contentType,
    responseType: responseType,
    receiveDataWhenStatusError: false,
    followRedirects: false,
    validateStatus: (status) => status != null && status < 401,
    headers: <String, dynamic>{
      ...?headers,
      'Idempotency-Key': finalIdempotencyKey,
    },
    extra: <String, dynamic>{
      'offline': isOffline,
      'idempotencyKey': finalIdempotencyKey,
      'priority': finalPriority.index,
      'category': finalCategory.index,
    },
  );

  if (authorization) {
    final accessToken = await PreferencesService.get(StorageKeys.token);
    if (!InputValidator.isVerifyNotEmpty(accessToken)) return null;
    options.headers?['Authorization'] = 'Bearer $accessToken';
  }

  options.headers?.addAll(await RequestHeaders.getHeaders());

  final requestUrl = '${baseUrl ?? defaultBaseUrl}$url';

  try {
    final response = await _sendRequest(
      method,
      requestUrl,
      params: params,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    return _handleResponse(response, isShowToast: isShowToast);
  } on DioException catch (error) {
    // 离线队列拦截器通过 cancel 表示已入队，调用方无需再弹错。
    if (error.type == DioExceptionType.cancel) return null;
    rethrow;
  } finally {
    if (isLoading) LoadingOverlay.instance.dismiss();
  }
}

QueuePriority _defaultPriority(RequestMethod method) {
  return switch (method) {
    RequestMethod.upload => QueuePriority.high,
    RequestMethod.get => QueuePriority.low,
    _ => QueuePriority.normal,
  };
}

QueueCategory _defaultCategory(RequestMethod method) {
  return method == RequestMethod.get
      ? QueueCategory.sync
      : QueueCategory.userAction;
}

Future<Response<dynamic>> _sendRequest(
  RequestMethod method,
  String url, {
  dynamic params,
  required Options options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
}) {
  return switch (method) {
    RequestMethod.head => HttpClient.instance.head(url, options: options),
    RequestMethod.get => HttpClient.instance.get(
      url,
      parameters: params,
      options: options,
    ),
    RequestMethod.put => HttpClient.instance.put(
      url,
      parameters: params,
      options: options,
    ),
    RequestMethod.delete => HttpClient.instance.delete(
      url,
      parameters: params,
      options: options,
    ),
    RequestMethod.post => HttpClient.instance.post(
      url,
      parameters: params,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    ),
    RequestMethod.upload => HttpClient.instance.upload(
      url,
      params: Map<String, dynamic>.from(params as Map),
      options: options,
      onSendProgress: onSendProgress,
    ),
  };
}

Future<dynamic> _handleResponse(
  Response<dynamic> response, {
  required bool isShowToast,
}) async {
  final statusCode = response.statusCode;

  if (statusCode == 200) {
    final data = _decodeResponseData(response.data);
    if (data is Map) {
      final code = data['code'];
      final msg = data['msg'];
      if (msg is String && msg.isNotEmpty && code != 200) {
        if (code == 401) {
          AppToast.show('登录过期，请重新登录');
          return null;
        }

        if (isShowToast) {
          final handled = await ResponseErrorHandler.handle(
            code: code is int ? code : int.tryParse(code.toString()),
            serverMsg: msg,
          );
          if (!handled) AppToast.show(msg);
        }
      }
    }
    return data;
  }

  if (statusCode == 400) return response.data;
  if (statusCode == 401) return null;
  if (statusCode == 404) return statusCode;

  return null;
}

dynamic _decodeResponseData(dynamic data) {
  if (data is! String) return data;
  try {
    return jsonDecode(data);
  } catch (_) {
    return data;
  }
}
