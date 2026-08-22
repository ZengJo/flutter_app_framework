# Globalization 全球化模块

这套模块不是只做“多语言翻译”，而是把语言、地区、货币、时区、单位制、12/24 小时制、LTR/RTL、HTTP Header 和本地持久化统一成一个基础能力。

## 1. 当前默认支持

- English（英语）：`en-US`
- 简体中文：`zh-Hans-CN`
- العربية（阿拉伯语）：`ar-SA`

底层地区、货币、时区能力是可扩展的，业务项目可以只开放自己需要的设置入口。

## 2. 第一次运行

当前项目已经采用“模块化翻译源文件 → 自动合并 ARB → Flutter gen_l10n”的生成流程。

第一次运行建议执行：

```bash
flutter pub get
dart run tool/l10n_generate.dart
flutter analyze
flutter run
```

其中：

```text
dart run tool/l10n_generate.dart
        ↓
tool/l10n_merge.dart
        ↓
生成 lib/l10n/app_en.arb
生成 lib/l10n/app_zh.arb
生成 lib/l10n/app_ar.arb
        ↓
flutter gen-l10n
        ↓
生成 AppLocalizations
```

正常开发时，不建议直接手工维护 `lib/l10n/app_*.arb`。真正需要长期维护的是项目根目录下的 `l10n_source/`。

如果只想检查模块 JSON 是否能够正确合并，而暂时不重新生成 Dart 本地化代码，可以单独执行：

```bash
dart run tool/l10n_merge.dart
```

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

当前项目已经采用模块化翻译资源，不再建议直接新建和手工维护 `lib/l10n/app_fr.arb`。

以 French（法语）为例：

1. 在 `lib/core/globalization/model/app_language.dart` 增加 `french`。
2. 在 `GlobalizationConfig.supportedLanguages` 增加 `AppLanguage.french`。
3. 在 `tool/l10n_merge.dart` 的 `locales` 中增加 `fr`。
4. 为每个现有翻译模块增加对应的 French 源文件，例如：

```text
l10n_source/
├── common/common_fr.json
├── network/network_fr.json
├── error/error_fr.json
├── permission/permission_fr.json
├── globalization/globalization_fr.json
├── language/language_fr.json
└── order/order_fr.json
```

5. Android 如需原生 App 名称，新建：

```text
android/app/src/main/res/values-fr/strings.xml
```

6. iOS 如需原生 App 名称，新建：

```text
ios/Runner/fr.lproj/InfoPlist.strings
```

并在 Xcode Localizations 中加入 French。

7. 执行：

```bash
dart run tool/l10n_generate.dart
```

脚本会自动生成：

```text
lib/l10n/app_fr.arb
        ↓
flutter gen-l10n
        ↓
AppLocalizations
```

新增语言后，不要只检查文字翻译，还需要继续检查 RTL、日期、数字、货币、单位、图片方向和 API Locale。

---

## 18. 翻译资源目录、ARB 生成与 Key 规范

### 18.1 为什么不再把所有翻译写进一个 ARB

当项目同时包含：

```text
Common
Network
Error
Permission
Globalization
Language
Order
Login
Device
Payment
...
```

如果全部直接写进：

```text
lib/l10n/app_zh.arb
lib/l10n/app_en.arb
lib/l10n/app_ar.arb
```

文件会快速增长到几百甚至几千行，查找和维护都比较困难。

因此本框架把“开发维护文件”和“Flutter 最终输入文件”分开：

```text
开发维护
l10n_source/
        ↓
自动合并
lib/l10n/app_*.arb
        ↓
Flutter gen_l10n
AppLocalizations
```

### 18.2 `l10n_source` 放在哪里

`l10n_source` 放在项目根目录，和 `lib`、`tool`、`pubspec.yaml` 同级。

推荐项目结构：

```text
flutter_app_framework/
├── android/
├── ios/
├── lib/
│   └── l10n/
│       ├── app_en.arb
│       ├── app_zh.arb
│       └── app_ar.arb
│
├── l10n_source/
│   ├── common/
│   ├── network/
│   ├── error/
│   ├── permission/
│   ├── globalization/
│   ├── language/
│   └── order/
│
├── tool/
│   ├── l10n_merge.dart
│   └── l10n_generate.dart
│
├── l10n.yaml
└── pubspec.yaml
```

原因：

```text
l10n_source/
= 开发人员维护的翻译源文件
= 工程工具输入
= App 运行时不直接读取

lib/l10n/
= 自动合并后的最终 ARB
= flutter gen-l10n 的输入
```

`l10n_source` 不属于 App 运行时代码，因此不需要放入 `lib/`。

---

### 18.3 当前模块划分

当前翻译按照以下 7 个模块维护：

```text
l10n_source/
├── common/
│   ├── common_en.json
│   ├── common_zh.json
│   └── common_ar.json
│
├── network/
│   ├── network_en.json
│   ├── network_zh.json
│   └── network_ar.json
│
├── error/
│   ├── error_en.json
│   ├── error_zh.json
│   └── error_ar.json
│
├── permission/
│   ├── permission_en.json
│   ├── permission_zh.json
│   └── permission_ar.json
│
├── globalization/
│   ├── globalization_en.json
│   ├── globalization_zh.json
│   └── globalization_ar.json
│
├── language/
│   ├── language_en.json
│   ├── language_zh.json
│   └── language_ar.json
│
└── order/
    ├── order_en.json
    ├── order_zh.json
    └── order_ar.json
```

模块职责：

| 模块            | 主要内容                                                 |
| --------------- | -------------------------------------------------------- |
| `common`        | App 名称、确认、取消、跟随系统、通用错误等公共文案       |
| `network`       | 网络断开、网络恢复、离线队列、同步状态等                 |
| `error`         | API、登录、文件路径、数据异常等错误文案                  |
| `permission`    | 相机、麦克风、相册、蓝牙、Wi-Fi、定位等权限文案          |
| `globalization` | 语言、地区、货币、时区、单位制、时间格式等通用全球化文案 |
| `language`      | Language Settings 页面、语言名称、系统语言提示等         |
| `order`         | Bloc 示例订单流程、订单状态、支付提示等                  |

以后新增业务时，优先新建自己的模块：

```text
l10n_source/auth/
l10n_source/device/
l10n_source/payment/
l10n_source/recipe/
```

不要把新的业务文案继续塞入 `common`。

---

### 18.4 `l10n_merge.dart` 是什么

文件：

```text
tool/l10n_merge.dart
```

职责只有一个：

> 把 `l10n_source` 中拆开的模块 JSON 合并为 Flutter `gen_l10n` 能识别的 `app_xx.arb`。

例如中文：

```text
common_zh.json
network_zh.json
error_zh.json
permission_zh.json
globalization_zh.json
language_zh.json
order_zh.json
        ↓
l10n_merge.dart
        ↓
lib/l10n/app_zh.arb
```

它同时负责：

- 按固定模块顺序合并。
- 自动写入 `@@locale`。
- 检查 JSON 是否有效。
- 检查模块文件是否缺失。
- 检查重复翻译 Key。
- 防止不同模块静默覆盖同一个 Key。

单独使用：

```bash
dart run tool/l10n_merge.dart
```

这个命令只生成 ARB，不执行 `flutter gen-l10n`。

---

### 18.5 `l10n_generate.dart` 是什么

文件：

```text
tool/l10n_generate.dart
```

它是开发人员平时使用的“一键生成入口”。

内部执行：

```text
dart run tool/l10n_merge.dart
        ↓
lib/l10n/app_*.arb
        ↓
flutter gen-l10n
        ↓
AppLocalizations
```

正常开发建议只记住：

```bash
dart run tool/l10n_generate.dart
```

两者关系：

```text
l10n_merge.dart
= 基础合并工具

l10n_generate.dart
= 开发人员入口
= merge + flutter gen-l10n
```

---

### 18.6 正常开发流程

例如 Order 模块新增“取消订单”：

中文：

```text
l10n_source/order/order_zh.json
```

```json
{
  "orderCancel": "取消订单"
}
```

英文：

```text
l10n_source/order/order_en.json
```

```json
{
  "orderCancel": "Cancel Order"
}
```

Arabic：

```text
l10n_source/order/order_ar.json
```

```json
{
  "orderCancel": "إلغاء الطلب"
}
```

然后执行：

```bash
dart run tool/l10n_generate.dart
```

业务页面继续使用：

```dart
Text(context.l10n.orderCancel)
```

业务代码不需要知道这些 Key 最终来自哪个 JSON 模块。

---

### 18.7 Key 命名规范

统一使用：

```text
模块 + 页面/状态/含义
```

不使用中文作为 Key。

推荐：

```text
commonUnknownError
networkOfflinePending
permissionCamera
globalizationTimeZone
languagePageTitle
orderStatusPaid
authLoginButton
deviceConnectFailed
```

不推荐：

```text
title
button
text1
message
unknown
登录按钮
```

Key 必须具有足够的业务语义，避免不同模块产生重复名称。

---

### 18.8 metadata 规则

`l10n.yaml` 当前使用：

```yaml
required-resource-attributes: false
```

因此普通静态文案不要求机械添加 `@key` metadata。

例如：

```json
{
  "commonFollowSystem": "跟随系统"
}
```

这是正常的，不需要再增加：

```json
"@commonFollowSystem": {
  "description": "..."
}
```

但是包含 Placeholder、Plural、Select 的复杂消息应保留 metadata。

例如：

```json
{
  "networkOfflinePending": "离线中，已缓存 {count} 条操作",

  "@networkOfflinePending": {
    "description": "网络离线时显示当前缓存的待同步操作数量",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

这样可以避免：

```text
The message with key "commonFollowSystem" does not have metadata defined.
```

以及：

```text
Resource attribute "@appName" was not found.
```

这类由强制 metadata 模式引起的报错。

---

### 18.9 `lib/l10n/app_*.arb` 是否可以手工修改

原则上：

> 不建议。

因为下一次执行：

```bash
dart run tool/l10n_generate.dart
```

`l10n_merge.dart` 会重新生成：

```text
lib/l10n/app_en.arb
lib/l10n/app_zh.arb
lib/l10n/app_ar.arb
```

手工修改可能被覆盖。

正确做法：

```text
发现某条中文需要修改
        ↓
修改 l10n_source/对应模块/xxx_zh.json
        ↓
修改其他语言对应文件
        ↓
dart run tool/l10n_generate.dart
```

---

### 18.10 `generated_preview` 是否需要保留

不需要。

`generated_preview` 只是首次把原来的三个大 ARB 拆成模块时，用来验证：

```text
拆分前 ARB
==
模块 JSON 重新合并后的 ARB
```

它不是正式运行目录，也不是生成链路的一部分。

正式项目可以删除：

```text
generated_preview/
```

正式保留：

```text
l10n_source/
tool/l10n_merge.dart
tool/l10n_generate.dart
lib/l10n/
l10n.yaml
```

---

### 18.11 推荐的最终生成链路

```text
开发人员
        ↓
修改 l10n_source/<module>/*.json
        ↓
dart run tool/l10n_generate.dart
        ↓
┌─────────────────────────────┐
│ l10n_merge.dart             │
│                             │
│ 模块 JSON → app_*.arb       │
└─────────────────────────────┘
        ↓
lib/l10n/app_*.arb
        ↓
flutter gen-l10n
        ↓
lib/core/globalization/generated/
AppLocalizations
        ↓
context.l10n.xxx
```

`lib/l10n/app_*.arb` 是中间生成文件，`AppLocalizations` 是最终 Dart 生成代码，而 `l10n_source` 才是开发人员日常维护的翻译源。

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

每新增一种语言，需要检查：

1. `AppLanguage` 是否增加语言定义。
2. `GlobalizationConfig.supportedLanguages` 是否加入。
3. `tool/l10n_merge.dart` 的 `locales` 是否加入新语言代码。
4. `l10n_source` 下每个现有模块是否都创建对应语言 JSON。
5. 各语言模块 Key 是否与基准语言保持一致。
6. `dart run tool/l10n_generate.dart` 是否执行成功。
7. 自动生成的 `lib/l10n/app_xx.arb` 是否存在。
8. `AppLocalizations` 是否重新生成成功。
9. Language Settings 页面是否自动出现新语言。
10. 原生 Android/iOS App 名称是否需要对应语言。
11. 是否属于 RTL 语言。
12. 公共页面是否使用 `start/end` 而不是 `left/right`。
13. 方向性图片是否使用 `AppGlobalizedImage`。
14. 带文字图片是否准备 Locale 独立资源或改为 Flutter Text。
15. API 是否接受对应的 `language` / `locale` Header。
16. 日期、数字、货币和单位显示是否符合目标市场。
17. 不要直接手工修改生成后的 `lib/l10n/app_xx.arb`。

Globalization 的目标不是“把文字翻译出来”，而是保证同一套业务逻辑在不同语言、地区和阅读方向下都能正确运行。
