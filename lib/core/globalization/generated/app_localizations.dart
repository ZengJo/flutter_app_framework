import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Flutter App Framework'**
  String get appName;

  /// No description provided for @commonFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get commonFollowSystem;

  /// No description provided for @commonSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get commonSystemDefault;

  /// No description provided for @commonUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get commonUnknownError;

  /// No description provided for @commonRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get commonRequestTimeout;

  /// No description provided for @networkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Actions will sync when the connection returns.'**
  String get networkUnavailable;

  /// No description provided for @networkOfflinePending.
  ///
  /// In en, this message translates to:
  /// **'Offline. {count} queued actions.'**
  String networkOfflinePending(int count);

  /// No description provided for @networkRecoveredReplaying.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Syncing {count} queued actions…'**
  String networkRecoveredReplaying(int count);

  /// No description provided for @networkSyncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync complete'**
  String get networkSyncComplete;

  /// No description provided for @errorLoginExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorLoginExpired;

  /// No description provided for @errorParameterMismatch.
  ///
  /// In en, this message translates to:
  /// **'Invalid request parameters'**
  String get errorParameterMismatch;

  /// No description provided for @errorOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get errorOperationFailed;

  /// No description provided for @errorJsonParseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse JSON'**
  String get errorJsonParseFailed;

  /// No description provided for @errorMethodValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Parameter validation failed'**
  String get errorMethodValidationFailed;

  /// No description provided for @errorRetryLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get errorRetryLater;

  /// No description provided for @errorUnknownEventType.
  ///
  /// In en, this message translates to:
  /// **'Unknown event type'**
  String get errorUnknownEventType;

  /// No description provided for @errorFilePathEmpty.
  ///
  /// In en, this message translates to:
  /// **'File path cannot be empty'**
  String get errorFilePathEmpty;

  /// No description provided for @errorFilePathInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'File path contains invalid characters'**
  String get errorFilePathInvalidCharacters;

  /// No description provided for @errorFileNameSuffixRequired.
  ///
  /// In en, this message translates to:
  /// **'The file name must contain a valid extension'**
  String get errorFileNameSuffixRequired;

  /// No description provided for @errorFileSuffixInvalid.
  ///
  /// In en, this message translates to:
  /// **'The file extension must contain 1–10 letters or numbers'**
  String get errorFileSuffixInvalid;

  /// No description provided for @errorFilePathInvalid.
  ///
  /// In en, this message translates to:
  /// **'The file path format is invalid'**
  String get errorFilePathInvalid;

  /// No description provided for @errorPlatformVersionMissing.
  ///
  /// In en, this message translates to:
  /// **'Platform version information is unavailable'**
  String get errorPlatformVersionMissing;

  /// No description provided for @errorDataInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get errorDataInvalid;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get errorLoginFailed;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get errorUserNotFound;

  /// No description provided for @errorIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get errorIncorrectPassword;

  /// No description provided for @permissionMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get permissionMicrophone;

  /// No description provided for @permissionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permissionCamera;

  /// No description provided for @permissionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get permissionPhotos;

  /// No description provided for @permissionNotification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotification;

  /// No description provided for @permissionPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get permissionPhone;

  /// No description provided for @permissionAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get permissionAudio;

  /// No description provided for @permissionStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get permissionStorage;

  /// No description provided for @permissionWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get permissionWifi;

  /// No description provided for @permissionBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get permissionBluetooth;

  /// No description provided for @permissionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get permissionLocation;

  /// No description provided for @permissionGeneric.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permissionGeneric;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'{permission} permission is disabled. Please enable it in Settings.'**
  String permissionOpenSettings(String permission);

  /// No description provided for @globalizationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get globalizationLanguage;

  /// No description provided for @globalizationRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get globalizationRegion;

  /// No description provided for @globalizationCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get globalizationCurrency;

  /// No description provided for @globalizationTimeZone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get globalizationTimeZone;

  /// No description provided for @globalizationUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get globalizationUnits;

  /// No description provided for @globalizationTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get globalizationTimeFormat;

  /// No description provided for @globalizationMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get globalizationMetric;

  /// No description provided for @globalizationImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get globalizationImperial;

  /// No description provided for @globalization12Hour.
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get globalization12Hour;

  /// No description provided for @globalization24Hour.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get globalization24Hour;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSimplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageSimplifiedChinese;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languagePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePageTitle;

  /// No description provided for @languagePageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used by the app. Changes take effect immediately.'**
  String get languagePageDescription;

  /// No description provided for @languageSystemCurrent.
  ///
  /// In en, this message translates to:
  /// **'System language: {language}'**
  String languageSystemCurrent(String language);

  /// No description provided for @languageChangeImmediatelyHint.
  ///
  /// In en, this message translates to:
  /// **'Language changes apply immediately. You do not need to restart the app.'**
  String get languageChangeImmediatelyHint;

  /// No description provided for @orderFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Flow'**
  String get orderFlowTitle;

  /// No description provided for @orderStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderStatusLabel;

  /// No description provided for @orderCreate.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get orderCreate;

  /// No description provided for @orderPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get orderPay;

  /// No description provided for @orderStatusInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get orderStatusInitial;

  /// No description provided for @orderStatusCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating order'**
  String get orderStatusCreating;

  /// No description provided for @orderStatusPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending payment'**
  String get orderStatusPendingPayment;

  /// No description provided for @orderStatusPaying.
  ///
  /// In en, this message translates to:
  /// **'Processing payment'**
  String get orderStatusPaying;

  /// No description provided for @orderStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderStatusPaid;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get orderStatusFailure;

  /// No description provided for @orderMessageCreatedPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Order created. Waiting for payment.'**
  String get orderMessageCreatedPendingPayment;

  /// No description provided for @orderMessagePaymentSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Payment successful.'**
  String get orderMessagePaymentSucceeded;

  /// No description provided for @orderMessageCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed.'**
  String get orderMessageCompleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
