import 'dart:convert';

enum QueuePriority { high, normal, low }

enum QueueCategory { userAction, sync, analytics, log }

/// 离线请求
class OfflineRequest {
  /// 请求ID
  final String id;

  /// 幂等键
  final String idempotencyKey;

  /// 请求方法
  final String method;

  /// 请求路径
  final String path;

  /// 请求参数
  final Map<String, dynamic>? query;

  /// 请求体
  final dynamic body;

  /// 请求头
  final Map<String, dynamic>? headers;

  /// 优先级
  final QueuePriority priority;

  /// 分类
  final QueueCategory category;

  /// 重试次数
  final int retryCount;

  /// 最大重试次数
  final int maxRetry;

  OfflineRequest({
    required this.id,
    required this.idempotencyKey,
    required this.method,
    required this.path,
    this.query,
    this.body,
    this.headers,
    this.priority = QueuePriority.normal,
    this.category = QueueCategory.sync,
    this.retryCount = 0,
    this.maxRetry = 3,
  });

  OfflineRequest copyWith({int? retryCount}) {
    return OfflineRequest(
      id: id,
      idempotencyKey: idempotencyKey,
      method: method,
      path: path,
      query: query,
      body: body,
      headers: headers,
      priority: priority,
      category: category,
      retryCount: retryCount ?? this.retryCount,
      maxRetry: maxRetry,
    );
  }

  bool get isDead => retryCount >= maxRetry;

  factory OfflineRequest.fromJson(Map<String, dynamic> json) {
    return OfflineRequest(
      id: json['id'],
      idempotencyKey: json['idempotencyKey'],
      method: json['method'],
      path: json['path'],
      query: json['query'],
      body: json['body'],
      headers: json['headers'],
      priority: QueuePriority.values[json['priority']],
      category: QueueCategory.values[json['category']],
      retryCount: json['retryCount'],
      maxRetry: json['maxRetry'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'idempotencyKey': idempotencyKey,
    'method': method,
    'path': path,
    'query': query,
    'body': body,
    'headers': headers,
    'priority': priority.index,
    'category': category.index,
    'retryCount': retryCount,
    'maxRetry': maxRetry,
  };

  String encode() => jsonEncode(toJson());
  static OfflineRequest decode(String raw) =>
      OfflineRequest.fromJson(jsonDecode(raw));
}
