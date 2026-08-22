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

## 20. Language Settings 语言切换业务模块

语言切换页面属于 `features/settings/language`，它是 Globalization 的业务入口，但不拥有独立的语言状态。

目录结构：

```text
features/
└── settings/
    └── language/
        ├── model/
        │   └── app_language_display_x.dart
        ├── providers/
        │   └── language_settings_provider.dart
        └── presentation/
            ├── pages/
            │   └── language_settings_page.dart
            └── widgets/
                └── language_option_tile.dart
```

当前页面默认展示：

```text
跟随系统
English
简体中文
العربية
```

### 业务职责

`LanguageSettingsPage` 负责：

- 展示当前支持语言。
- 展示当前系统语言。
- 显示用户当前选择。
- 支持“跟随系统”。
- 调用 `GlobalizationController.setLanguage(...)` 切换语言。
- 切换后立即刷新当前页面和整个 App。
- Arabic 环境下自动切换 RTL 布局。

`LanguageSettingsPage` 不负责：

- 直接操作 SharedPreferences。
- 自己保存 Locale。
- 自己创建 `LanguageBloc`。
- 自己判断 `isArabic`。
- 自己维护第二份 LanguageState。

### 为什么“跟随系统”和“手动中文”要分开

假设当前手机系统语言本来就是简体中文。

下面两种情况最终 Locale 都可能是 `zh-Hans-CN`：

```text
情况 A
用户选择：跟随系统
系统：简体中文

情况 B
用户选择：简体中文
系统：简体中文
```

但两者业务含义不同。

以后系统语言改成 English：

```text
情况 A → App 自动变 English
情况 B → App 仍保持简体中文
```

因此语言设置页面不能只根据最终 `GlobalizationState.language` 判断选中状态，还必须读取 `GlobalizationPreferences.followSystemLanguage`。

---

## 21. Language Settings 业务流程

完整流程：

```text
App 启动
        ↓
GlobalizationBootstrap
        ↓
读取 GlobalizationPreferences
        ↓
GlobalizationResolver
        ↓
生成 GlobalizationState
        ↓
MaterialApp(locale: state.locale)
        ↓
用户进入 LanguageSettingsPage
        ↓
languageSettingsProvider
        ↓
读取：
- GlobalizationState
- GlobalizationPreferences
- System Locale
        ↓
展示语言列表
        ↓
用户点击 العربية
        ↓
GlobalizationController.setLanguage(AppLanguage.arabic)
        ↓
保存 Preferences
        ↓
重新 Resolve
        ↓
GlobalizationState = ar-SA / RTL
        ↓
┌────────────────────────────────┐
│ MaterialApp 重新构建           │
│ ARB 文案变为 Arabic            │
│ Directionality 变为 RTL        │
│ 日期/数字/货币 Formatter 更新  │
│ Dio 后续请求 Header 使用 ar-SA │
└────────────────────────────────┘
```

整个流程不需要：

```text
重启 App
重新进入首页
重新创建 Dio
```

---

## 22. Riverpod 与 Bloc 的职责边界

Globalization 使用 Riverpod，不代表所有 Feature 都应该使用 Riverpod。

本框架约定：

### Riverpod

用于 App / Core / Infrastructure：

```text
Globalization
Theme
Network
Dio
Repository Provider
Service Provider
Dependency Injection
App Config
轻量全局状态
```

Globalization 特别适合 Riverpod，因为同一份状态同时会被以下模块使用：

```text
MaterialApp
Dio Interceptor
Date Formatter
Currency Formatter
Unit Formatter
Bootstrap
Language Settings Page
```

### Bloc

用于具体 Feature 的复杂业务流程：

```text
Login
Order
Payment
Device
Recipe
复杂分页
复杂表单流程
```

例如订单：

```text
PayOrderRequested
        ↓
OrderBloc
        ↓
Loading
        ↓
Repository
        ↓
Success / Error
        ↓
OrderState
```

### Language Settings 不需要 LanguageBloc

当前结构：

```text
LanguageSettingsPage
        ↓
languageSettingsProvider
        ↓
globalizationProvider
```

其中：

- `globalizationProvider` 是唯一真实状态源。
- `languageSettingsProvider` 只是页面 View State / Selector。
- 页面通过 `GlobalizationController` 修改状态。

不要再增加：

```text
LanguageBloc
        ↓
GlobalizationController
```

否则只会多一层事件转发，并产生双状态同步风险。

---

## 23. Globalized Assets 图片全球化

多语言项目除了文字方向，图片本身也可能存在方向差异。

图片资源统一分为 4 类：

| 类型               | 策略          | 典型场景                             |
| ------------------ | ------------- | ------------------------------------ |
| 固定图片           | `fixed`       | Logo、商品图、头像、二维码、人物照片 |
| RTL 自动镜像       | `mirrorOnRtl` | 简单箭头、无文字手势、简单方向图     |
| LTR / RTL 独立图片 | `directional` | 复杂流程图、带方向构图的插画         |
| Locale 独立图片    | `localized`   | 带文字 Banner、UI 截图、市场独立素材 |

### 业务层统一入口

有方向或语言差异的图片优先使用：

```dart
AppGlobalizedImage(
  asset: AppAssets.connectGuide,
)
```

不要在业务页面写：

```dart
if (isArabic) {
  return Image.asset('xxx_ar.webp');
}
```

也不要把 Arabic 与 RTL 绑定。

正确方向判断来源是：

```dart
Directionality.of(context)
```

因为以后：

```text
Arabic → RTL
Hebrew → RTL
English → LTR
Chinese → LTR
```

### 资源命名规范

固定资源：

```text
logo.webp
product.webp
```

方向资源：

```text
connect_guide_ltr.webp
connect_guide_rtl.webp
```

语言资源：

```text
home_banner_en.webp
home_banner_zh.webp
home_banner_ar.webp
```

### 图片包含文字时

优先建议：

```text
背景图片
+
Flutter Text / Button
```

而不是把文字直接烘焙进图片。

这样新增语言时通常只需要新增 ARB 文案，不需要重新制作每一种语言的 Banner。

如果图片本身必须包含文字，则使用 `localized` 策略为不同 Locale 准备独立资源。

---

## 24. RTL UI 与图片规范

RTL 适配不等于“所有东西水平翻转”。

### 应该跟随方向

```text
文本 start/end 对齐
返回方向
列表前后关系
Padding start/end
Positioned start/end
流程箭头
部分手势图
```

### 不应该翻转

```text
Logo
商品实拍图
人脸
二维码
国旗
设备真实照片
图片中的文字
手机 UI 截图
```

公共 UI 优先：

```dart
TextAlign.start
AlignmentDirectional.centerStart
EdgeInsetsDirectional.only(start: 16, end: 8)
PositionedDirectional(start: 16, child: child)
```

方向图片优先：

```dart
AppGlobalizedImage(
  asset: AppAssets.xxx,
)
```

业务代码原则上不出现：

```dart
language == AppLanguage.arabic
```

来决定 UI 左右方向。

---

## 25. 新增语言后的业务检查清单

每新增一种语言，除了创建 ARB，还需要检查：

1. `AppLanguage` 是否增加语言定义。
2. `GlobalizationConfig.supportedLanguages` 是否加入。
3. `app_xx.arb` Key 是否与模板语言一致。
4. `flutter gen-l10n` 是否生成成功。
5. Language Settings 页面是否自动出现新语言。
6. 原生 Android/iOS App 名称是否需要对应语言。
7. 是否属于 RTL 语言。
8. 公共页面是否使用 `start/end` 而不是 `left/right`。
9. 方向性图片是否使用 `AppGlobalizedImage`。
10. 带文字图片是否准备 Locale 独立资源或改为 Flutter Text。
11. API 是否接受对应的 `language` / `locale` Header。
12. 日期、数字、货币和单位显示是否符合目标市场。

Globalization 的目标不是“把文字翻译出来”，而是保证同一套业务逻辑在不同语言、地区和阅读方向下都能正确运行。
