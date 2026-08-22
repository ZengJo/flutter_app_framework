# Class Reference

本章节说明项目中主要类、枚举、Provider 的职责，避免后续开发时不知道类的用途。

---

## App Layer Classes

| Class / File              | 作用                                                         |
| ------------------------- | ------------------------------------------------------------ |
| `Application`             | App 根组件，负责挂载 `MaterialApp`、主题、路由等应用级配置。 |
| `ApplicationBootstrapper` | 应用启动引导器，负责统一执行启动前初始化任务。               |
| `ApplicationInitTask`     | 启动任务模型，用于描述一个初始化任务。                       |
| `ApplicationInitializer`  | 初始化任务执行器，负责按顺序执行多个启动任务。               |
| `BootstrapContext`        | 启动上下文，用于在初始化阶段传递全局依赖或配置。             |
| `runAppHandle`            | App 启动封装函数，用于统一处理异常、初始化和运行 App。       |
| `ApplicationConfig`       | 应用配置类，统一管理 App 名称、接口地址、环境配置等。        |
| `AppEnvironment`          | 应用环境枚举，区分 `development`、`staging`、`production`。  |
| `AppEnvironmentX`         | 环境枚举扩展，用于获取环境名称、是否生产环境等辅助信息。     |
| `globalKeyNavigatorKey`   | 全局导航 Key，用于在非 Widget 场景下执行页面跳转。           |
| `PageScope`               | 页面级依赖作用域，用于在页面树中传递页面状态或依赖。         |
| `AppNavigator`            | 应用导航管理器，统一封装页面跳转、返回、替换等导航操作。     |
| `AppRouter`               | 应用导航管理路由                                             |
| `AppPageRoute`            | 自定义页面路由，统一页面切换动画和路由行为。                 |
| `RouteObserverService`    | 路由监听服务，用于监听页面进入、退出、切换等生命周期。       |
| `RouteNames`              | 路由名称常量类，统一管理页面路由字符串。                     |
| `AppTheme`                | 应用主题类，统一管理亮色主题、暗色主题、颜色和字体样式。     |

---

## Core / Device Classes

| Class               | 作用                                                             |
| ------------------- | ---------------------------------------------------------------- |
| `DeviceInfoService` | 设备信息服务，统一获取设备型号、系统版本、App 版本、包名等信息。 |

---

## Core / Network Classes

| Class / File              | 作用                                                            |
| ------------------------- | --------------------------------------------------------------- |
| `DioClientHolder`         | Dio 实例持有器，负责创建、配置、缓存和复用 Dio 实例。           |
| `HttpClient`              | 网络请求客户端，统一封装 GET、POST、PUT、DELETE 等请求。        |
| `NetworkMonitor`          | 网络状态监听器，用于监听当前设备是否联网。                      |
| `Reachability`            | 网络可达状态枚举，包含 `unknown`、`online`、`offline`。         |
| `NetworkState`            | 网络状态模型，用于描述当前网络连接状态。                        |
| `ResponseErrorHandler`    | HTTP 响应错误处理器，统一处理接口错误、状态码异常等问题。       |
| `RequestHeaders`          | 请求头管理类，统一生成 Token、语言、版本号、设备信息等 Header。 |
| `RequestMethod`           | 请求方法枚举，包含 GET、POST、PUT、DELETE、HEAD、UPLOAD。       |
| `request`                 | 通用请求方法，用于根据请求参数统一发起网络请求。                |
| `OfflineQueueInterceptor` | 离线请求拦截器，当网络不可用时拦截请求并加入离线队列。          |
| `OfflineQueueManager`     | 离线队列管理器，负责请求入队、重试、清理和恢复发送。            |
| `OfflineQueueState`       | 离线队列状态模型，用于描述队列数量、处理中状态等信息。          |
| `OfflineQueueStorage`     | 离线队列本地存储服务，负责把离线请求保存到本地。                |
| `OfflineRequest`          | 离线请求模型，保存请求地址、参数、Header、请求方法等信息。      |
| `QueuePriority`           | 离线请求优先级枚举，区分高、中、低优先级。                      |
| `QueueCategory`           | 离线请求分类枚举，例如用户操作、同步、统计、日志等。            |
| `IdempotencyKeyGenerator` | 幂等 Key 生成器，用于生成唯一请求标识，避免重复提交。           |

---

## Core / Network Providers

| Provider                      | 作用                                            |
| ----------------------------- | ----------------------------------------------- |
| `dioProvider`                 | Riverpod Provider，用于全局提供 Dio 实例。      |
| `dioInterceptorsProvider`     | Riverpod Provider，用于注册 Dio 拦截器。        |
| `networkMonitorProvider`      | Riverpod Provider，用于提供网络监听服务。       |
| `networkStateProvider`        | Riverpod StreamProvider，用于监听网络状态变化。 |
| `offlineQueueManagerProvider` | Riverpod Provider，用于提供离线队列管理器。     |
| `offlineQueueStateProvider`   | Riverpod StreamProvider，用于监听离线队列状态。 |
| `offlineQueueStorageProvider` | Riverpod Provider，用于提供离线队列存储服务。   |

---

## Core / Logger Classes

| Class       | 作用                                                          |
| ----------- | ------------------------------------------------------------- |
| `AppLogger` | 应用日志工具类，统一输出 Debug、Info、Warning、Error 等日志。 |

> 项目中不要直接使用 `print()` 输出日志，统一使用 `AppLogger`，方便后续控制 Release 环境日志。

---

## Core / State Classes

| Class / Enum             | 作用                                                       |
| ------------------------ | ---------------------------------------------------------- |
| `BaseBloc<Event, State>` | Bloc 基础类，用于统一扩展 Bloc 的公共能力。                |
| `BaseEvent`              | Bloc 事件基类，所有 Event 可以继承它，方便统一比较和测试。 |
| `BaseState`              | Bloc 状态基类，所有 State 可以继承它，方便统一比较和测试。 |
| `AppProviderObserver`    | Riverpod 状态监听器，用于调试 Provider 创建、更新、销毁。  |

---

## Core / Globalization Classes

Globalization 模块属于 App 级基础设施能力，负责统一管理语言、Locale、地区、货币、时区、单位制、12/24 小时制、LTR/RTL、HTTP Header 以及本地持久化。

该模块的核心原则：

- `GlobalizationState` 是当前 App 真正生效的全球化状态。
- `GlobalizationPreferences` 保存用户的选择，例如“跟随系统语言”或“手动选择 Arabic”。
- 业务页面不要直接读写 SharedPreferences，统一通过 `GlobalizationController` 修改。
- 业务层不要自己判断 `isArabic`，方向相关逻辑优先使用 `Directionality`、`start/end`。
- Globalization 使用 Riverpod 管理，因为它会同时被 `MaterialApp`、Dio、Formatter、Bootstrap 和多个 Feature 使用。

### Classes

| Class / Enum                 | 作用                                                                                                  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------- |
| `GlobalizationConfig`        | 全球化配置入口，统一定义支持语言、默认 Locale、默认地区、默认货币等配置。                             |
| `AppLanguage`                | App 支持语言枚举，保存语言码、API 语言码、原生语言名称等稳定信息。                                    |
| `GlobalizationPreferences`   | 用户全球化偏好模型，保存是否跟随系统语言/地区/时区、指定货币、单位制等设置。                          |
| `GlobalizationState`         | 当前 App 真正生效的全球化状态，包含 Locale、语言、地区、货币、时区、单位制、12/24 小时制和 RTL 状态。 |
| `MeasurementSystem`          | 单位制枚举，区分 `system`、`metric`、`imperial`。                                                     |
| `AppHourCycle`               | 时间制式枚举，区分 `system`、`h12`、`h24`。                                                           |
| `GlobalizationBootstrap`     | App 启动前的全球化初始化入口，负责读取本地偏好并解析初始状态。                                        |
| `GlobalizationBootstrapData` | 启动阶段的全球化初始化数据模型，用于向 ProviderContainer 注入初始配置。                               |
| `GlobalizationController`    | 全球化状态控制器，统一处理语言、地区、货币、时区、单位制和时间制式切换，并负责持久化。                |
| `GlobalizationResolver`      | 全球化总解析器，根据用户偏好与系统环境计算最终 `GlobalizationState`。                                 |
| `LocaleResolver`             | Locale / 语言解析器，负责系统语言匹配、Fallback 和 App 支持语言映射。                                 |
| `RegionResolver`             | 地区解析器，根据系统地区或用户配置计算当前地区。                                                      |
| `GlobalizationStorage`       | 全球化偏好存储层，统一负责 `GlobalizationPreferences` 的本地读写。                                    |
| `GlobalizationRuntime`       | 当前全球化运行时环境持有器，供非 Widget 场景读取实时状态。                                            |
| `GlobalizationSystemService` | 系统全球化信息服务，负责读取系统 Locale、时区、12/24 小时制等信息。                                   |
| `GlobalizationInterceptor`   | Dio 全球化拦截器，在每次请求时动态加入语言、地区、货币、时区等 Header。                               |
| `AppDateFormatter`           | 日期时间格式化器，根据当前 Locale、时区和 12/24 小时制格式化时间。                                    |
| `AppNumberFormatter`         | 数字格式化器，根据当前 Locale 格式化普通数字、百分比、紧凑数字等。                                    |
| `AppCurrencyFormatter`       | 货币格式化器，根据当前 Locale 和货币码显示金额；只负责格式化，不负责汇率转换。                        |
| `AppUnitFormatter`           | 单位格式化器，根据公制/英制转换并格式化温度、距离、重量等单位。                                       |
| `LocalizationContextX`       | `BuildContext` 本地化扩展，提供 `context.l10n` 快捷访问。                                             |

### Providers

| Provider                       | 作用                                                                                       |
| ------------------------------ | ------------------------------------------------------------------------------------------ |
| `globalizationProvider`        | Globalization 的唯一主状态源，提供当前 `GlobalizationState` 和 `GlobalizationController`。 |
| `appDateFormatterProvider`     | 根据当前 Globalization 状态提供日期时间格式化器。                                          |
| `appNumberFormatterProvider`   | 根据当前 Globalization 状态提供数字格式化器。                                              |
| `appCurrencyFormatterProvider` | 根据当前 Globalization 状态提供货币格式化器。                                              |
| `appUnitFormatterProvider`     | 根据当前 Globalization 状态提供单位格式化器。                                              |

### Localization Resource / Tooling

翻译资源采用“模块化源文件 + 自动合并”的工程结构。`lib/l10n/app_*.arb` 是生成结果，不是日常主要维护入口。

| File / Directory             | 作用                                                                                             |
| ---------------------------- | ------------------------------------------------------------------------------------------------ |
| `l10n_source/`               | 项目根目录下的模块化翻译源文件目录，是开发人员日常维护翻译的主要入口。                           |
| `l10n_source/common/`        | 公共文案模块，例如 App 名称、跟随系统、通用错误等。                                              |
| `l10n_source/network/`       | 网络断开、恢复、离线队列、同步状态等网络文案。                                                   |
| `l10n_source/error/`         | API、登录、文件路径、数据异常等错误文案。                                                        |
| `l10n_source/permission/`    | 相机、麦克风、相册、蓝牙、Wi-Fi、定位等权限文案。                                                |
| `l10n_source/globalization/` | 地区、货币、时区、单位制、时间格式等全球化公共文案。                                             |
| `l10n_source/language/`      | Language Settings 页面和语言名称等文案。                                                         |
| `l10n_source/order/`         | Bloc 示例订单流程相关文案。                                                                      |
| `tool/l10n_merge.dart`       | 基础合并工具，把各模块 JSON 合并为 `lib/l10n/app_*.arb`，并检查缺失模块、重复 Key 和 JSON 格式。 |
| `tool/l10n_generate.dart`    | 开发人员一键入口，先执行 `l10n_merge.dart`，再执行 `flutter gen-l10n` 生成 `AppLocalizations`。  |
| `lib/l10n/app_*.arb`         | Flutter `gen_l10n` 的最终输入文件，由合并脚本生成，原则上不直接手工维护。                        |
| `l10n.yaml`                  | Flutter 本地化生成配置，定义 ARB 目录、模板文件、输出路径和 metadata 策略。                      |
| `AppLocalizations`           | Flutter `gen_l10n` 自动生成的本地化访问类，业务层通过 `context.l10n` 使用。                      |

### Localization Generation Workflow

```text
开发人员修改
l10n_source/<module>/<module>_<locale>.json
        ↓
dart run tool/l10n_generate.dart
        ↓
tool/l10n_merge.dart
        ↓
lib/l10n/app_en.arb
lib/l10n/app_zh.arb
lib/l10n/app_ar.arb
        ↓
flutter gen-l10n
        ↓
AppLocalizations
        ↓
context.l10n.xxx
```

### 两个脚本的职责区别

```text
l10n_merge.dart
= 只负责模块 JSON → app_*.arb
= 基础工具
= 可单独用于检查合并结果

l10n_generate.dart
= l10n_merge.dart + flutter gen-l10n
= 正常开发时推荐使用的一键入口
```

正常开发优先执行：

```bash
dart run tool/l10n_generate.dart
```

不要直接修改：

```text
lib/l10n/app_en.arb
lib/l10n/app_zh.arb
lib/l10n/app_ar.arb
```

因为下一次运行合并脚本时会重新生成这些文件。

### Translation Module Placement Rule

新增 Feature 时，如果产生较多独立业务文案，应优先新建对应翻译模块：

```text
features/auth
        ↓
l10n_source/auth/

features/device
        ↓
l10n_source/device/

features/payment
        ↓
l10n_source/payment/
```

不要为了方便把具体业务文案全部放到 `common`。

翻译 Key 继续使用：

```text
模块 + 页面/状态/含义
```

例如：

```text
authLoginButton
deviceConnectFailed
paymentStatusPending
```

普通静态文案不强制 metadata；带 Placeholder、Plural、Select 的复杂消息应保留 `@key` metadata。

---

## Core / Storage Classes

| Class                | 作用                                               |
| -------------------- | -------------------------------------------------- |
| `PreferencesService` | SharedPreferences 封装服务，统一处理本地数据读写。 |
| `StorageKeys`        | 本地存储 Key 常量类，避免字符串 Key 散落在项目中。 |

---

## Core / Utils Classes

| Class              | 作用                                                                       |
| ------------------ | -------------------------------------------------------------------------- |
| `InputValidator`   | 输入校验工具类，用于校验手机号、邮箱、密码、非空等规则。                   |
| `ScreenResponsive` | 响应式尺寸适配工具，根据设计稿宽度自动计算缩放比例，统一适配不同屏幕尺寸。 |

---

# Core / Permission

Permission 模块统一管理应用中的权限申请、权限检测、平台适配以及权限状态记录。

整体设计目标：

- 不直接依赖 `permission_handler`
- 业务层只关心业务权限，不关心 Android / iOS 差异
- Android 不同版本自动适配
- 所有权限申请统一入口
- 支持首次申请记录
- 支持跳转系统设置

目录结构：

```text
core/
└── permission/
    ├── enum_permission.dart
    ├── permission_request.dart
    ├── permission_resolver.dart
    ├── permission_handler.dart
    └── permission_request_record.dart
```

---

## Classes

| Class                     | 作用                                                 |
| ------------------------- | ---------------------------------------------------- |
| `PermissionRequest`       | 权限枚举，业务层统一使用的权限类型。                 |
| `PermissionType`          | 权限分类枚举，用于描述支持的权限类型。               |
| `PermissionResolver`      | 权限解析器，根据平台和系统版本解析真实权限。         |
| `PermissionHandler`       | 权限统一管理器，负责申请、检测、跳转系统设置等能力。 |
| `PermissionRequestRecord` | 权限申请记录管理器，用于记录用户是否申请过某项权限。 |

---

## PermissionRequest

业务层不要直接使用 `Permission`。

统一使用：

```dart
PermissionRequest.camera
PermissionRequest.microphone
PermissionRequest.bluetooth
PermissionRequest.wifi
PermissionRequest.photos
```

这样可以避免：

- Android 权限变化
- iOS 权限差异
- Android 13+
- Android 12+
- 后续系统升级导致业务代码修改

---

## PermissionResolver

PermissionResolver 专门负责：

根据不同平台解析真实权限。

例如：

Wi-Fi：

```text
Android
↓

Location
```

蓝牙：

```text
Android 12+
↓

Bluetooth Scan
Bluetooth Connect
```

Android 11 以下：

```text
Bluetooth
```

相册：

```text
Android 13+

↓

Photos

Android 12-

↓

Storage
```

业务层永远不知道这些差异。

---

## PermissionHandler

统一负责：

- 检查权限
- 申请权限
- 多权限申请
- 权限弹窗
- 跳转系统设置
- 判断权限状态

例如：

申请相机权限：

```dart
final granted =
    await PermissionHandler.instance.requestPermissionByType(
  PermissionRequest.camera,
);
```

申请多个权限：

```dart
await PermissionHandler.instance.requestPermissionsByType([
  PermissionRequest.camera,
  PermissionRequest.microphone,
]);
```

检查权限：

```dart
final hasPermission =
    await PermissionHandler.instance.checkPermissionByType(
  PermissionRequest.bluetooth,
);
```

---

## PermissionRequestRecord

用于记录：

> 用户是否已经申请过某个权限。

例如：

```dart
await PermissionRequestRecord.instance.markRequested(
    PermissionRequest.camera);
```

判断：

```dart
final requested =
    await PermissionRequestRecord.instance.hasRequested(
        PermissionRequest.camera);
```

适用于：

- 首次授权引导
- 不再重复弹说明页
- 权限教育页
- 首次启动流程

---

## Shared / Form Classes

| Class                | 作用                                                             |
| -------------------- | ---------------------------------------------------------------- |
| `FormViewState`      | 表单整体状态模型，用于描述表单是否加载、是否可提交、错误信息等。 |
| `FormFieldViewState` | 单个表单字段状态模型，用于描述字段值、错误信息、是否必填等。     |
| `AppForm`            | 应用统一表单容器，用于统一表单布局和提交逻辑。                   |
| `AppTextField`       | 应用统一输入框组件，封装输入、校验、错误提示、样式等能力。       |
| `_AppTextFieldState` | `AppTextField` 的内部状态类，负责维护输入框状态。                |

---

## Shared / Feedback Classes

| Class                 | 作用                                                            |
| --------------------- | --------------------------------------------------------------- |
| `AppToast`            | Toast 提示工具类，统一显示成功、失败、警告、普通提示。          |
| `_ToastWidget`        | Toast 内部 UI 组件，负责 Toast 的实际展示样式。                 |
| `LoadingOverlay`      | 全局 Loading 浮层工具，用于接口请求、页面加载、文件上传等场景。 |
| `NetworkStatusBanner` | 网络状态提示条，当网络断开或恢复时显示提示。                    |
| `_OfflineBanner`      | 离线状态提示条内部组件。                                        |

---

## Shared / Gesture Classes

| Class              | 作用                                               |
| ------------------ | -------------------------------------------------- |
| `AppTapArea`       | 通用点击区域组件，封装点击、防抖、触摸反馈等能力。 |
| `_AppTapAreaState` | `AppTapArea` 的内部状态类，负责处理点击状态。      |

---

## Shared / Image Classes

| Class / Enum                | 作用                                                                                                   |
| --------------------------- | ------------------------------------------------------------------------------------------------------ |
| `AppCachedImage`            | 网络缓存图片组件，封装图片加载、缓存、占位图、错误图。                                                 |
| `AdvancedImageCacheManager` | 图片缓存管理器，负责管理网络图片缓存策略。                                                             |
| `AppImage`                  | 应用统一图片组件，支持资源图片、网络图片、Base64、文件图片，并支持 `matchTextDirection` RTL 自动镜像。 |
| `AppGlobalizedImage`        | 全球化图片组件，根据当前 Locale / Directionality 自动选择固定图、镜像图、LTR/RTL 图或语言独立图。      |
| `AppAsset`                  | 全球化图片资源定义模型，用于声明图片采用 fixed、mirrorOnRtl、directional 或 localized 策略。           |
| `AppAssetStrategy`          | 图片全球化策略枚举，区分固定资源、RTL 自动镜像、LTR/RTL 独立资源和 Locale 独立资源。                   |
| `AppAssetResolver`          | 全球化图片资源解析器，根据 Locale 和文字方向解析最终图片路径及是否自动镜像。                           |
| `ResolvedAppAsset`          | 图片解析结果模型，保存最终资源路径和 `matchTextDirection` 配置。                                       |
| `_ImageType`                | 图片类型枚举，用于区分 asset、network、base64、file 等图片来源。                                       |
| `_AppImageState`            | `AppImage` 的内部状态类，负责判断图片类型并渲染。                                                      |

---

## Shared / Layout Classes

| Class         | 作用                                                              |
| ------------- | ----------------------------------------------------------------- |
| `AppScaffold` | 应用统一页面骨架，封装 Scaffold、AppBar、Body、背景色等通用结构。 |

---

## Shared / Page Classes

| Class | 作用 |
| `BaseRiverpodPage<S, VM extends StateNotifier<S>>` | Riverpod 页面基类，负责绑定 Provider 与 ViewModel，统一页面结构、生命周期管理和状态管理入口。 |
| `BaseRiverpodState<T, S, VM extends StateNotifier<S>>` | Riverpod 页面状态基类，负责页面初始化、Provider 状态读取、ViewModel 获取、页面缓存、导航栏配置以及页面容器构建。 |
| `BaseBlocPage<S, B extends BlocBase<S>>` | Bloc 页面基类，负责创建并注入 Bloc/Cubit，统一页面结构、生命周期管理和状态管理入口。 |
| `BaseBlocState<T, S, B extends BlocBase<S>>` | Bloc 页面状态基类，负责页面初始化、Bloc 获取、状态监听（BlocListener）、状态刷新（BlocBuilder）、页面缓存、导航栏配置以及页面容器构建。 |

---

## Shared / Text Classes

| Class           | 作用                                                                   |
| --------------- | ---------------------------------------------------------------------- |
| `AppText`       | 应用统一文本组件，封装字体大小、颜色、行高、对齐方式等常用 Text 配置。 |
| `_AppTextState` | `AppText` 的内部状态类，负责处理文本组件状态。                         |

---

## Feature / Example Classes

| Class         | 作用                                                 |
| ------------- | ---------------------------------------------------- |
| `ExamplePage` | 示例页面，用于展示框架的基础页面结构和组件使用方式。 |

---

## Feature / Riverpod Example Classes

| Class / Provider  | 作用                                                        |
| ----------------- | ----------------------------------------------------------- |
| `counterProvider` | Riverpod 示例 Provider，用于管理计数器状态。                |
| `CounterNotifier` | 计数器状态控制器，负责增加、减少、重置计数。                |
| `CounterPage`     | Riverpod 示例页面，用于展示如何通过 Provider 驱动 UI 刷新。 |

---

## Feature / Bloc Example Classes

| Class                    | 作用                                                     |
| ------------------------ | -------------------------------------------------------- |
| `OrderEvent`             | 订单 Bloc 事件基类，用于描述订单流程中发生的行为。       |
| `CreateOrderRequested`   | 创建订单事件，表示用户触发创建订单操作。                 |
| `PayOrderRequested`      | 支付订单事件，表示用户触发支付操作。                     |
| `CompleteOrderRequested` | 完成订单事件，表示订单流程完成。                         |
| `OrderStatus`            | 订单状态枚举，用于描述订单当前所处阶段。                 |
| `OrderState`             | 订单状态模型，保存当前订单状态、提示信息、错误信息等。   |
| `OrderBloc`              | 订单业务流程控制器，接收事件、处理业务逻辑、输出新状态。 |
| `OrderPage`              | Bloc 示例页面，用于展示如何通过 Bloc 管理复杂业务流程。  |

---

## Feature / Language Settings Classes

Language Settings 是 Globalization 的业务入口页面，只负责展示和触发语言选择，不建立第二套语言状态。

业务规则：

- 真正的语言状态只有 `globalizationProvider` 一份。
- 页面 Provider 只整理展示数据，不负责持久化。
- “跟随系统”与“用户手动选择当前系统同一种语言”必须能够区分。
- 切换语言后当前页面和整个 App 立即刷新，不需要重启。
- Arabic 等 RTL 语言切换后，页面通过 `Directionality` 自动切换为 RTL。
- 语言名称优先显示自身原生名称，例如 `English`、`简体中文`、`العربية`，避免用户切错语言后无法识别设置项。

| Class / Provider           | 作用                                                                                             |
| -------------------------- | ------------------------------------------------------------------------------------------------ |
| `LanguageSettingsPage`     | 语言切换页面，展示跟随系统和当前支持语言，并调用 `GlobalizationController` 完成切换。            |
| `LanguageOptionTile`       | 单个语言选项组件，负责语言名称、原生名称、选中状态、系统选项和 RTL 自适应布局。                  |
| `LanguageSettingsState`    | 语言设置页只读 View State，包含是否跟随系统、当前生效语言、系统语言和支持语言列表。              |
| `languageSettingsProvider` | 语言设置页面只读 Provider，从 `globalizationProvider` 派生页面需要的数据，不保存第二份语言状态。 |
| `AppLanguageDisplayX`      | `AppLanguage` 的页面展示扩展，负责获取当前 UI 语言下的语言名称和语言 Badge。                     |

### Language Settings Workflow

```text
用户进入语言设置页
        ↓
languageSettingsProvider
        ↓
读取 globalizationProvider + 用户 Preferences
        ↓
展示：
- 跟随系统
- English
- 简体中文
- العربية
        ↓
用户点击某个语言
        ↓
GlobalizationController.setLanguage(...)
        ↓
更新 GlobalizationPreferences
        ↓
重新解析 GlobalizationState
        ↓
┌──────────────────────────────┐
│ MaterialApp Locale 更新      │
│ LTR / RTL 自动更新           │
│ ARB 文案立即更新             │
│ Dio 下一条请求 Header 更新   │
│ 本地偏好持久化               │
└──────────────────────────────┘
```

---

# Bloc Example Workflow

Bloc 适合复杂业务流程，例如订单流程。

```text
用户点击创建订单
        ↓
CreateOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: pendingPayment)
        ↓
UI 刷新为待支付状态
```

支付流程：

```text
用户点击支付
        ↓
PayOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: paid)
        ↓
UI 刷新为支付成功状态
```

完成流程：

```text
订单完成
        ↓
CompleteOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: completed)
        ↓
UI 刷新为订单完成状态
```

---

# Riverpod Example Workflow

Riverpod 在本框架中主要负责 App/Core 级基础设施状态、全局依赖以及轻量状态，例如 Globalization、Theme、Network、Repository Provider、计数器等。具体业务流程仍优先使用 Bloc。

```text
用户点击按钮
        ↓
CounterNotifier.increment()
        ↓
counterProvider 状态更新
        ↓
ConsumerWidget 自动刷新 UI
```

---

# State Management Boundary

本框架同时保留 Riverpod 和 Bloc，但两者职责必须明确，避免同一个业务同时维护两份状态。

## Riverpod 负责

主要用于 App / Core / Infrastructure：

```text
Globalization
Theme
Network
Dio
Repository / Service Provider
Dependency Injection
App Config
轻量全局状态
```

特点：

- 生命周期跨多个页面或整个 App。
- 可能同时被 UI、网络层、Bootstrap、Service 使用。
- 更适合作为依赖注入和全局基础设施状态入口。

## Bloc 负责

主要用于 Feature / Business：

```text
Login
Register
Order
Payment
Device
Recipe
复杂列表
页面业务流程
```

特点：

- 存在明确 Event → Logic → State 流程。
- 包含 Loading / Success / Error / Retry 等业务状态。
- 状态生命周期通常跟某个 Feature 或页面流程绑定。

## Important Rule

不要为了“统一状态管理框架”把所有能力都强行改成 Bloc 或 Provider。

例如语言设置：

```text
LanguageSettingsPage
        ↓
languageSettingsProvider（只读 View State）
        ↓
globalizationProvider（唯一真实状态源）
```

不需要再增加：

```text
LanguageBloc
        ↓
GlobalizationProvider
```

否则会形成重复状态和无意义的中间层。

---

# ScreenResponsive Usage

`ScreenResponsive` 用于统一管理项目中的尺寸适配，根据设计稿宽度自动计算缩放比例。

## 初始化

```dart
@override
Widget build(BuildContext context) {
  ScreenResponsive.init(context);

  return const Scaffold(
    body: ...
  );
}
```

默认设计稿宽度为 **375**。

自定义设计稿：

```dart
ScreenResponsive.init(
  context,
  designWidth: 390,
);
```

限制缩放范围：

```dart
ScreenResponsive.init(
  context,
  designWidth: 375,
  minScale: 0.85,
  maxScale: 1.25,
);
```

## 使用

```dart
Container(
  width: 120.adapt,
  height: 48.adapt,
  padding: EdgeInsets.all(16.adapt),
  margin: EdgeInsets.symmetric(horizontal: 20.adapt),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.adapt),
  ),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: 16.adapt,
    ),
  ),
)
```

```dart
Icon(
  Icons.home,
  size: 24.adapt,
)
```

## Best Practice

统一使用 `.adapt` 进行尺寸适配：

- width
- height
- padding
- margin
- fontSize
- borderRadius
- iconSize

---

# Class Placement Rules

## 放到 core 的类

满足以下条件时放入 `core`：

- 与 UI 无关
- 与具体业务无关
- 多个模块都需要
- 属于基础设施能力

例如：

```text
HttpClient
PreferencesService
DeviceInfoService
AppLogger
GlobalizationController
GlobalizationResolver
AppDateFormatter
```

---

## 放到 shared 的类

满足以下条件时放入 `shared`：

- 是 UI 组件
- 多个业务页面都会使用
- 不包含具体业务逻辑

例如：

```text
AppText
AppImage
AppGlobalizedImage
AppTextField
AppToast
LoadingOverlay
```

---

## 放到 features 的类

满足以下条件时放入 `features`：

- 只服务于某个业务模块
- 包含业务状态
- 包含业务页面
- 包含业务流程

例如：

```text
LoginPage
OrderBloc
UserProvider
OrderRepository
LanguageSettingsPage
```

---

## 放到 `tool` / `l10n_source` 的内容

工程生成脚本和翻译源文件不属于 App 运行时代码，不放入 `lib/core`、`lib/shared` 或 `features`。

```text
tool/
├── l10n_merge.dart
└── l10n_generate.dart

l10n_source/
├── common/
├── network/
├── error/
├── permission/
├── globalization/
├── language/
└── order/
```

其中：

- `tool/`：工程辅助脚本。
- `l10n_source/`：模块化翻译源文件。
- `lib/l10n/`：脚本生成后的 Flutter ARB 输入目录。
- `lib/core/globalization/generated/`：Flutter `gen_l10n` 生成的 Dart 代码目录。

---

# Important Rule

不要为了“看起来通用”过早把代码放到 `core` 或 `shared`。

推荐原则：

```text
先放 features
真正复用后再抽到 shared 或 core
```
