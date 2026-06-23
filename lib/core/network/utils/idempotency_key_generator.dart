import 'package:uuid/uuid.dart';

/// 幂等工具类
class IdempotencyKeyGenerator {
  /// UUID
  static const _uuid = Uuid();

  /// 业务未指定时自动生成
  static String generate() {
    return _uuid.v4();
  }
}
