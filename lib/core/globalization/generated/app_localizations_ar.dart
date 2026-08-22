// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'إطار تطبيق Flutter';

  @override
  String get commonFollowSystem => 'اتباع النظام';

  @override
  String get commonSystemDefault => 'إعداد النظام الافتراضي';

  @override
  String get commonUnknownError => 'خطأ غير معروف';

  @override
  String get commonRequestTimeout => 'انتهت مهلة الطلب';

  @override
  String get networkUnavailable =>
      'الشبكة غير متاحة. ستتم مزامنة العمليات عند عودة الاتصال.';

  @override
  String networkOfflinePending(int count) {
    return 'أنت غير متصل. هناك $count عمليات في قائمة الانتظار.';
  }

  @override
  String networkRecoveredReplaying(int count) {
    return 'عاد الاتصال. جارٍ مزامنة $count عمليات…';
  }

  @override
  String get networkSyncComplete => 'اكتملت المزامنة';

  @override
  String get errorLoginExpired =>
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorParameterMismatch => 'معلمات الطلب غير صالحة';

  @override
  String get errorOperationFailed => 'فشلت العملية';

  @override
  String get errorJsonParseFailed => 'فشل تحليل JSON';

  @override
  String get errorMethodValidationFailed => 'فشل التحقق من المعلمات';

  @override
  String get errorRetryLater => 'يرجى المحاولة مرة أخرى لاحقًا';

  @override
  String get errorUnknownEventType => 'نوع حدث غير معروف';

  @override
  String get errorFilePathEmpty => 'لا يمكن أن يكون مسار الملف فارغًا';

  @override
  String get errorFilePathInvalidCharacters =>
      'يحتوي مسار الملف على أحرف غير صالحة';

  @override
  String get errorFileNameSuffixRequired =>
      'يجب أن يحتوي اسم الملف على امتداد صالح';

  @override
  String get errorFileSuffixInvalid =>
      'يجب أن يتكون امتداد الملف من 1 إلى 10 أحرف أو أرقام';

  @override
  String get errorFilePathInvalid => 'تنسيق مسار الملف غير صالح';

  @override
  String get errorPlatformVersionMissing => 'معلومات إصدار النظام غير متاحة';

  @override
  String get errorDataInvalid => 'بيانات غير صالحة';

  @override
  String get errorLoginFailed => 'فشل تسجيل الدخول';

  @override
  String get errorUserNotFound => 'المستخدم غير موجود';

  @override
  String get errorIncorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get permissionMicrophone => 'الميكروفون';

  @override
  String get permissionCamera => 'الكاميرا';

  @override
  String get permissionPhotos => 'الصور';

  @override
  String get permissionNotification => 'الإشعارات';

  @override
  String get permissionPhone => 'الهاتف';

  @override
  String get permissionAudio => 'الصوت';

  @override
  String get permissionStorage => 'التخزين';

  @override
  String get permissionWifi => 'Wi-Fi';

  @override
  String get permissionBluetooth => 'البلوتوث';

  @override
  String get permissionLocation => 'الموقع';

  @override
  String get permissionGeneric => 'الإذن';

  @override
  String permissionOpenSettings(String permission) {
    return 'إذن $permission معطل. يرجى تفعيله من الإعدادات.';
  }

  @override
  String get globalizationLanguage => 'اللغة';

  @override
  String get globalizationRegion => 'المنطقة';

  @override
  String get globalizationCurrency => 'العملة';

  @override
  String get globalizationTimeZone => 'المنطقة الزمنية';

  @override
  String get globalizationUnits => 'الوحدات';

  @override
  String get globalizationTimeFormat => 'تنسيق الوقت';

  @override
  String get globalizationMetric => 'متري';

  @override
  String get globalizationImperial => 'إمبراطوري';

  @override
  String get globalization12Hour => '12 ساعة';

  @override
  String get globalization24Hour => '24 ساعة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageSimplifiedChinese => 'الصينية المبسطة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languagePageTitle => 'اللغة';

  @override
  String get languagePageDescription =>
      'اختر اللغة المستخدمة في التطبيق. سيتم تطبيق التغيير فورًا.';

  @override
  String languageSystemCurrent(String language) {
    return 'لغة النظام: $language';
  }

  @override
  String get languageChangeImmediatelyHint =>
      'يتم تطبيق تغيير اللغة فورًا ولا حاجة إلى إعادة تشغيل التطبيق.';

  @override
  String get orderFlowTitle => 'مسار الطلب';

  @override
  String get orderStatusLabel => 'الحالة';

  @override
  String get orderCreate => 'إنشاء الطلب';

  @override
  String get orderPay => 'الدفع';

  @override
  String get orderStatusInitial => 'الحالة الأولية';

  @override
  String get orderStatusCreating => 'جارٍ إنشاء الطلب';

  @override
  String get orderStatusPendingPayment => 'بانتظار الدفع';

  @override
  String get orderStatusPaying => 'جارٍ معالجة الدفع';

  @override
  String get orderStatusPaid => 'تم الدفع';

  @override
  String get orderStatusCompleted => 'مكتمل';

  @override
  String get orderStatusFailure => 'فشل';

  @override
  String get orderMessageCreatedPendingPayment =>
      'تم إنشاء الطلب وهو بانتظار الدفع.';

  @override
  String get orderMessagePaymentSucceeded => 'تم الدفع بنجاح.';

  @override
  String get orderMessageCompleted => 'اكتمل الطلب.';
}
