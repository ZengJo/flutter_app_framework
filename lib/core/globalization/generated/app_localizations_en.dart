// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter App Framework';

  @override
  String get commonFollowSystem => 'Follow system';

  @override
  String get commonSystemDefault => 'System default';

  @override
  String get commonUnknownError => 'Unknown error';

  @override
  String get commonRequestTimeout => 'Request timed out';

  @override
  String get networkUnavailable =>
      'Network unavailable. Actions will sync when the connection returns.';

  @override
  String networkOfflinePending(int count) {
    return 'Offline. $count queued actions.';
  }

  @override
  String networkRecoveredReplaying(int count) {
    return 'Connection restored. Syncing $count queued actions…';
  }

  @override
  String get networkSyncComplete => 'Sync complete';

  @override
  String get errorLoginExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorParameterMismatch => 'Invalid request parameters';

  @override
  String get errorOperationFailed => 'Operation failed';

  @override
  String get errorJsonParseFailed => 'Failed to parse JSON';

  @override
  String get errorMethodValidationFailed => 'Parameter validation failed';

  @override
  String get errorRetryLater => 'Please try again later';

  @override
  String get errorUnknownEventType => 'Unknown event type';

  @override
  String get errorFilePathEmpty => 'File path cannot be empty';

  @override
  String get errorFilePathInvalidCharacters =>
      'File path contains invalid characters';

  @override
  String get errorFileNameSuffixRequired =>
      'The file name must contain a valid extension';

  @override
  String get errorFileSuffixInvalid =>
      'The file extension must contain 1–10 letters or numbers';

  @override
  String get errorFilePathInvalid => 'The file path format is invalid';

  @override
  String get errorPlatformVersionMissing =>
      'Platform version information is unavailable';

  @override
  String get errorDataInvalid => 'Invalid data';

  @override
  String get errorLoginFailed => 'Sign-in failed';

  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorIncorrectPassword => 'Incorrect password';

  @override
  String get permissionMicrophone => 'Microphone';

  @override
  String get permissionCamera => 'Camera';

  @override
  String get permissionPhotos => 'Photos';

  @override
  String get permissionNotification => 'Notifications';

  @override
  String get permissionPhone => 'Phone';

  @override
  String get permissionAudio => 'Audio';

  @override
  String get permissionStorage => 'Storage';

  @override
  String get permissionWifi => 'Wi-Fi';

  @override
  String get permissionBluetooth => 'Bluetooth';

  @override
  String get permissionLocation => 'Location';

  @override
  String get permissionGeneric => 'Permission';

  @override
  String permissionOpenSettings(String permission) {
    return '$permission permission is disabled. Please enable it in Settings.';
  }

  @override
  String get globalizationLanguage => 'Language';

  @override
  String get globalizationRegion => 'Region';

  @override
  String get globalizationCurrency => 'Currency';

  @override
  String get globalizationTimeZone => 'Time zone';

  @override
  String get globalizationUnits => 'Units';

  @override
  String get globalizationTimeFormat => 'Time format';

  @override
  String get globalizationMetric => 'Metric';

  @override
  String get globalizationImperial => 'Imperial';

  @override
  String get globalization12Hour => '12-hour';

  @override
  String get globalization24Hour => '24-hour';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSimplifiedChinese => 'Simplified Chinese';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get orderFlowTitle => 'Order Flow';

  @override
  String get orderStatusLabel => 'Status';

  @override
  String get orderCreate => 'Create order';

  @override
  String get orderPay => 'Pay';

  @override
  String get orderStatusInitial => 'Initial';

  @override
  String get orderStatusCreating => 'Creating order';

  @override
  String get orderStatusPendingPayment => 'Pending payment';

  @override
  String get orderStatusPaying => 'Processing payment';

  @override
  String get orderStatusPaid => 'Paid';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusFailure => 'Failed';

  @override
  String get orderMessageCreatedPendingPayment =>
      'Order created. Waiting for payment.';

  @override
  String get orderMessagePaymentSucceeded => 'Payment successful.';

  @override
  String get orderMessageCompleted => 'Order completed.';

  @override
  String get languagePageTitle => 'Language';

  @override
  String get languagePageDescription =>
      'Choose the language used by the app. Changes take effect immediately.';

  @override
  String languageSystemCurrent(String language) {
    return 'System language: $language';
  }

  @override
  String get languageChangeImmediatelyHint =>
      'Language changes apply immediately. You do not need to restart the app.';
}
