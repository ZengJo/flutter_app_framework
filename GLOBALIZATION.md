# Globalization 全球化模块

这套模块不是只做“多语言翻译”，而是把语言、地区、货币、时区、单位制、12/24 小时制、LTR/RTL、HTTP Header 和本地持久化统一成一个基础能力。

## 1. 当前默认支持

- English（英语）：`en-US`
- 简体中文：`zh-Hans-CN`
- العربية（阿拉伯语）：`ar-SA`

底层地区、货币、时区能力是可扩展的，业务项目可以只开放自己需要的设置入口。

## 2. 第一次运行

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter run
```

`flutter pub get` / `flutter run` 也会触发 Flutter 的本地化代码生成，但第一次接入时建议主动执行一次 `flutter gen-l10n`，方便 IDE 立即识别 `AppLocalizations`。

## 3. 页面读取翻译

```dart
import 'package:flutter_app_framework/core/globalization/globalization.dart';

Text(context.l10n.globalizationLanguage)
```

## 4. Riverpod 读取当前全球化状态

```dart
final globalization = ref.watch(globalizationProvider);

print(globalization.locale);             // 例如 ar_SA
print(globalization.regionCode);         // 例如 SA
print(globalization.currencyCode);       // 例如 SAR
print(globalization.timeZoneId);         // 例如 Asia/Riyadh
print(globalization.measurementSystem);  // metric / imperial
print(globalization.hourCycle);          // h12 / h24
print(globalization.isRtl);              // true / false
```

## 5. 切换语言

```dart
final controller = ref.read(globalizationProvider.notifier);

// English（英语）
await controller.setLanguage(AppLanguage.english);

// 简体中文
await controller.setLanguage(AppLanguage.simplifiedChinese);

// العربية（阿拉伯语）
await controller.setLanguage(AppLanguage.arabic);

// 跟随系统语言
await controller.setLanguage(null);
```

切换后不需要重启 App，也不需要重建 Dio。

## 6. 修改地区

```dart
final controller = ref.read(globalizationProvider.notifier);

// United States（美国）
await controller.setRegion('US');

// United Kingdom（英国）
await controller.setRegion('GB');

// Saudi Arabia（沙特阿拉伯）
await controller.setRegion('SA');

// 跟随系统地区
await controller.setRegion(null);
```

地区码使用 ISO 3166-1 Alpha-2。

## 7. 修改货币

```dart
final controller = ref.read(globalizationProvider.notifier);

await controller.setCurrency('USD');
await controller.setCurrency('EUR');
await controller.setCurrency('CNY');
await controller.setCurrency('SAR');

// 跟随当前地区默认货币
await controller.setCurrency(null);
```

注意：Globalization 的货币能力只负责显示格式，不负责真实汇率转换。

## 8. 修改时区

```dart
final controller = ref.read(globalizationProvider.notifier);

await controller.setTimeZone('America/Los_Angeles');
await controller.setTimeZone('Asia/Shanghai');
await controller.setTimeZone('Asia/Riyadh');

// 跟随系统时区
await controller.setTimeZone(null);
```

可用 IANA 时区：

```dart
final zones = await GlobalizationSystemService.availableTimeZoneIds();
```

## 9. 修改单位制

```dart
await ref
    .read(globalizationProvider.notifier)
    .setMeasurementSystem(MeasurementSystem.metric); // 公制

await ref
    .read(globalizationProvider.notifier)
    .setMeasurementSystem(MeasurementSystem.imperial); // 英制

await ref
    .read(globalizationProvider.notifier)
    .setMeasurementSystem(MeasurementSystem.system); // 跟随地区
```

## 10. 修改 12 / 24 小时制

```dart
await ref
    .read(globalizationProvider.notifier)
    .setHourCycle(AppHourCycle.h12); // 12 小时制

await ref
    .read(globalizationProvider.notifier)
    .setHourCycle(AppHourCycle.h24); // 24 小时制

await ref
    .read(globalizationProvider.notifier)
    .setHourCycle(AppHourCycle.system); // 跟随系统真实设置
```

## 11. 日期格式化

```dart
final formatter = ref.watch(appDateFormatterProvider);

final serverUtc = DateTime.parse('2026-08-22T12:00:00Z');

final shortDate = formatter.shortDate(serverUtc);
final longDate = formatter.longDate(serverUtc);
final time = formatter.time(serverUtc);
final dateTime = formatter.dateTime(serverUtc);
```

约定：服务端和数据库优先使用 UTC，展示时再由 Globalization 转换到用户时区。

## 12. 数字格式化

```dart
final formatter = ref.watch(appNumberFormatterProvider);

formatter.decimal(1234567.89, decimalDigits: 2);
formatter.compact(1250000);
formatter.percent(0.256, decimalDigits: 1);
```

## 13. 货币格式化

```dart
final formatter = ref.watch(appCurrencyFormatterProvider);

// 使用当前 GlobalizationState.currencyCode
formatter.format(1299.99);

// 临时指定币种
formatter.format(1299.99, currencyCode: 'EUR');
```

## 14. 单位格式化

输入统一使用公制基础值：

```dart
final formatter = ref.watch(appUnitFormatterProvider);

formatter.temperatureCelsius(25); // °C / °F
formatter.distanceKilometers(10); // km / mi
formatter.weightKilograms(5);     // kg / lb
```

## 15. HTTP Header

每次 Dio 请求都会实时加入当前全球化状态：

```text
language: ar-SA
locale: ar-SA
Accept-Language: ar-SA
region: SA
currency: SAR
timezone: Asia/Riyadh
measurementSystem: metric
```

`RequestHeaders` 只缓存设备型号、系统版本、App 版本等静态 Header，因此切换语言后下一条请求会立即使用新语言。

## 16. RTL 页面规范

业务 UI 尽量使用方向感知 API：

```dart
// 推荐
EdgeInsetsDirectional.only(start: 16, end: 8)
AlignmentDirectional.centerStart
PositionedDirectional(start: 16, child: child)
TextAlign.start

// 尽量避免写死方向
// EdgeInsets.only(left: 16)
// Alignment.centerLeft
// Positioned(left: 16)
// TextAlign.left
```

## 17. 新增一种语言

以 French（法语）为例：

1. 在 `lib/core/globalization/model/app_language.dart` 增加 `french`。
2. 在 `GlobalizationConfig.supportedLanguages` 增加它。
3. 新建 `lib/l10n/app_fr.arb`，Key 必须和 `app_en.arb` 一致。
4. Android 如需原生 App 名称，新建 `android/app/src/main/res/values-fr/strings.xml`。
5. iOS 如需原生 App 名称，新建 `ios/Runner/fr.lproj/InfoPlist.strings` 并在 Xcode Localizations 中加入 French。
6. 运行 `flutter gen-l10n`。

## 18. ARB Key 规范

统一使用“模块 + 页面/含义”的英文 Key，不使用中文作为 Key：

```text
commonUnknownError
authLoginButton
orderStatusPaid
permissionCamera
globalizationTimeZone
```

ARB 是 JSON 格式，本身不支持 `//` 注释；需要说明时使用 `@key` metadata。

## 19. 业务层不要保存已经翻译好的字符串

错误示例：

```dart
emit(state.copyWith(message: '支付成功'));
```

推荐：

```dart
emit(
  state.copyWith(
    messageType: OrderMessageType.paymentSucceeded,
  ),
);
```

页面展示时再映射：

```dart
final text = switch (state.messageType) {
  OrderMessageType.paymentSucceeded => context.l10n.orderMessagePaymentSucceeded,
  _ => '',
};
```

这样用户切换语言后，当前页面可以立即重新渲染为新语言，不需要重新执行业务请求。
