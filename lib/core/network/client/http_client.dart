import 'package:dio/dio.dart';

import 'dio_holder.dart';

/// Dio 轻量封装：去掉重复分支，统一通过 dio.request 处理普通请求。
class HttpClient {
  HttpClient._();

  static final HttpClient instance = HttpClient._();

  static bool isLoading = true;

  static void setLoading(bool loading) {
    isLoading = loading;
  }

  Dio get _dio => DioClientHolder.instance.dio;

  Future<Response<dynamic>> head(String url, {Options? options}) {
    return _dio.head<dynamic>(url, options: options);
  }

  Future<Response<dynamic>> get(
    String url, {
    dynamic parameters,
    Options? options,
  }) {
    return _dio.get<dynamic>(
      url,
      queryParameters: parameters,
      options: options,
    );
  }

  Future<Response<dynamic>> post(
    String url, {
    dynamic parameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return _dio.post<dynamic>(
      url,
      data: parameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<dynamic>> put(
    String url, {
    dynamic parameters,
    Options? options,
  }) {
    return _dio.put<dynamic>(url, data: parameters, options: options);
  }

  Future<Response<dynamic>> delete(
    String url, {
    dynamic parameters,
    Options? options,
  }) {
    return _dio.delete<dynamic>(url, data: parameters, options: options);
  }

  Future<Response<dynamic>> upload(
    String url, {
    required Map<String, dynamic> params,
    String fileKey = 'file',
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    final filePath = params[fileKey] ?? params['filePath'];
    if (filePath is! String || filePath.isEmpty) {
      throw ArgumentError("文件路径未找到，请确保参数中有 '$fileKey' 或 'filePath'");
    }

    final formMap = Map<String, dynamic>.from(params)
      ..remove(fileKey)
      ..remove('filePath');

    formMap[fileKey] = await MultipartFile.fromFile(
      filePath,
      filename: params['fileName']?.toString() ?? filePath.split('/').last,
    );

    return _dio.post<dynamic>(
      url,
      data: FormData.fromMap(formMap),
      options: options,
      onSendProgress: onSendProgress,
    );
  }
}
