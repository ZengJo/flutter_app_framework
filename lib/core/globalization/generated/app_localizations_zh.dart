// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Flutter 通用框架';

  @override
  String get commonFollowSystem => '跟随系统';

  @override
  String get commonSystemDefault => '系统默认';

  @override
  String get commonUnknownError => '未知错误';

  @override
  String get commonRequestTimeout => '请求超时';

  @override
  String get networkUnavailable => '网络不可用，操作将在恢复后同步';

  @override
  String networkOfflinePending(int count) {
    return '离线中，已缓存 $count 条操作';
  }

  @override
  String networkRecoveredReplaying(int count) {
    return '网络已恢复，正在同步 $count 条操作…';
  }

  @override
  String get networkSyncComplete => '同步完成';

  @override
  String get errorLoginExpired => '登录已过期，请重新登录';

  @override
  String get errorParameterMismatch => '传参不匹配';

  @override
  String get errorOperationFailed => '操作失败';

  @override
  String get errorJsonParseFailed => 'JSON 解析失败';

  @override
  String get errorMethodValidationFailed => '方法级参数校验失败';

  @override
  String get errorRetryLater => '请稍候重试';

  @override
  String get errorUnknownEventType => '未知事件类型';

  @override
  String get errorFilePathEmpty => '文件路径不能为空';

  @override
  String get errorFilePathInvalidCharacters => '文件路径含非法字符';

  @override
  String get errorFileNameSuffixRequired => '文件名必须包含有效后缀';

  @override
  String get errorFileSuffixInvalid => '文件后缀必须为 1-10 位字母或数字';

  @override
  String get errorFilePathInvalid => '文件路径必须符合规范';

  @override
  String get errorPlatformVersionMissing => '无平台版本信息';

  @override
  String get errorDataInvalid => '数据异常';

  @override
  String get errorLoginFailed => '登录失败';

  @override
  String get errorUserNotFound => '用户不存在';

  @override
  String get errorIncorrectPassword => '密码错误';

  @override
  String get permissionMicrophone => '麦克风';

  @override
  String get permissionCamera => '相机';

  @override
  String get permissionPhotos => '相册';

  @override
  String get permissionNotification => '通知';

  @override
  String get permissionPhone => '电话';

  @override
  String get permissionAudio => '音频';

  @override
  String get permissionStorage => '存储';

  @override
  String get permissionWifi => 'Wi-Fi';

  @override
  String get permissionBluetooth => '蓝牙';

  @override
  String get permissionLocation => '定位';

  @override
  String get permissionGeneric => '权限';

  @override
  String permissionOpenSettings(String permission) {
    return '$permission权限未开启，请前往设置';
  }

  @override
  String get globalizationLanguage => '语言';

  @override
  String get globalizationRegion => '地区';

  @override
  String get globalizationCurrency => '货币';

  @override
  String get globalizationTimeZone => '时区';

  @override
  String get globalizationUnits => '单位';

  @override
  String get globalizationTimeFormat => '时间格式';

  @override
  String get globalizationMetric => '公制';

  @override
  String get globalizationImperial => '英制';

  @override
  String get globalization12Hour => '12 小时制';

  @override
  String get globalization24Hour => '24 小时制';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageArabic => '阿拉伯语';

  @override
  String get orderFlowTitle => '订单流程';

  @override
  String get orderStatusLabel => '状态';

  @override
  String get orderCreate => '创建订单';

  @override
  String get orderPay => '支付';

  @override
  String get orderStatusInitial => '初始状态';

  @override
  String get orderStatusCreating => '正在创建订单';

  @override
  String get orderStatusPendingPayment => '等待支付';

  @override
  String get orderStatusPaying => '正在支付';

  @override
  String get orderStatusPaid => '已支付';

  @override
  String get orderStatusCompleted => '已完成';

  @override
  String get orderStatusFailure => '失败';

  @override
  String get orderMessageCreatedPendingPayment => '订单创建成功，等待支付。';

  @override
  String get orderMessagePaymentSucceeded => '支付成功。';

  @override
  String get orderMessageCompleted => '订单已完成。';
}
