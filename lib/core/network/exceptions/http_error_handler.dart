import '../../../shared/widgets/feedback/app_toast.dart';

/// 处理后端非 200 业务状态码
class ResponseErrorHandler {
  /// 统一维护错误提示词
  static
  /// HTTP 响应错误码 → 提示文案
  const Map<int, String> httpErrorCodeMap = {
    10001: "传参不匹配",
    10002: "操作失败",
    10003: "JSON解析失败",
    10004: "方法级参数校验失败",
    10005: "请稍候重试",
    10006: "未知事件类型",

    10016: "文件路径不能为空",
    10017: "文件路径含非法字符",
    10018: "文件名必须包含有效后缀",
    10019: "文件后缀必须为1-10位字母或数字",
    10020: "文件路径必须符合规范",

    13001: "无平台版本信息",
    14001: "数据异常",

    20001: "登录失败",
    20002: "用户不存在",
    20003: "密码错误",
  };

  /// 处理逻辑：返回 true 表示已处理（调用方不用再继续 toast/fallback）
  /// [code] 后端返回的业务状态码
  /// [serverMsg] 后端返回的业务状态码对应的提示信息
  /// [isShowToast] 是否显示 toast
  static Future<bool> handle({
    int? code,
    required String serverMsg,
    bool isShowToast = true,
  }) async {
    if (code == null) {
      return false;
    }
    final mapped = httpErrorCodeMap[code];
    if (mapped != null && mapped.isNotEmpty) {
      if (isShowToast) AppToast.show(mapped);
      return true;
    } else {
      // 处理未知错误状态码
      return false;
    }
  }
}
